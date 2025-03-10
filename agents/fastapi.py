from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import json
from datetime import datetime, timedelta
from geopy.distance import geodesic
from google.oauth2 import service_account
from google.cloud import aiplatform
from langchain_google_vertexai import VertexAI, VertexAIEmbeddings
from langchain_chroma import Chroma
from langchain.docstore.document import Document

# Load blood bank data
with open("bloodbank.json", "r") as f:
    blood_bank_data = json.load(f)

# Initialize Vertex AI
credentials = service_account.Credentials.from_service_account_file("vertical-setup-450217-n2-8904fd8695bd.json")
aiplatform.init(project="strategy-agent", location="us-central1", credentials=credentials)

# Initialize Vertex AI components
llm = VertexAI(model_name="gemini-1.5-flash", credentials=credentials, max_output_tokens=3000, temperature=0.7)
embeddings = VertexAIEmbeddings(model_name="textembedding-gecko@003", credentials=credentials)

# Create vector store
documents = [Document(page_content=f"Pincode {zone['pincode']}: {json.dumps(zone)}", metadata={"pincode": zone["pincode"]}) for zone in blood_bank_data]
vector_store = Chroma.from_documents(documents=documents, embedding=embeddings, persist_directory="./chroma_db")
vector_store.persist_directory = "./chroma_db"  # Ensure persistence

# Initialize FastAPI app
app = FastAPI()

class BloodRequest(BaseModel):
    blood_group: str
    
class PredictShortages(BaseModel):
    shortages: str

class DonationAppointment(BaseModel):
    donor_name: str
    donor_location: List[float]  
    blood_group: str

def find_blood_banks_by_group(blood_group: str):
    matching_banks = [
        bank for bank in blood_bank_data
        if blood_group in bank["available_blood_groups"] and bank["available_blood_groups"][blood_group] > 0
    ]
    if not matching_banks:
        # Gather all available blood groups in the data for debugging (optional)
        all_blood_groups = set()
        for bank in blood_bank_data:
            all_blood_groups.update(bank["available_blood_groups"].keys())
        return {
            "message": f"No blood banks found with {blood_group} availability.",
            "available_blood_groups_in_data": sorted(list(all_blood_groups))
        }
    return {"blood_banks": matching_banks}

def predict_blood_shortages(threshold=5):
    shortages = [
        {
            "name": bank["name"],
            "district": bank["district"],
            "state": bank["state"],
            "low_stock": [blood_group for blood_group, units in bank["available_blood_groups"].items() if units < threshold]
        }
        for bank in blood_bank_data
        if any(units < threshold for units in bank["available_blood_groups"].values())
    ]
    return {"shortages": shortages} if shortages else {"message": "All blood banks have sufficient stock."}

def schedule_donation_appointment(donor_name: str, donor_location: List[float], blood_group: str):
    if not blood_bank_data:
        return {"message": "No blood banks available in the system."}
    
    nearest_bank = min(
        blood_bank_data,
        key=lambda bank: geodesic(donor_location, (bank["latitude"], bank["longitude"])).km
    )

    appointment_time = datetime.now() + timedelta(days=1, hours=2)
    return {
        "donor": donor_name,
        "blood_group": blood_group,
        "blood_bank": nearest_bank["name"],
        "location": f"{nearest_bank['district']}, {nearest_bank['state']}",
        "appointment_time": appointment_time.strftime('%Y-%m-%d %H:%M')
    }

@app.get("/find_blood_banks")
def get_blood_banks(blood_group: str):
    """
    Find blood banks with available blood group
    """
    return find_blood_banks_by_group(blood_group)

@app.get("/predict_shortages")
def get_blood_shortages(threshold: int = 5):
    """
    Predict blood shortages based on threshold
    """
    return predict_blood_shortages(threshold)

@app.post("/schedule_appointment")
def book_appointment(appointment: DonationAppointment):
    """
    Schedule a blood donation appointment
    """
    return schedule_donation_appointment(
        appointment.donor_name,
        appointment.donor_location,
        appointment.blood_group
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)