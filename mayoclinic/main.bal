import ballerina/http;

// In-memory table to store physician data
table<Physician> key(id) physicianTable = table [];

// Sample data initialization
function init() {
    Physician physician1 = {
        id: "PHY001",
        firstName: "John",
        lastName: "Smith",
        speciality: "Cardiology",
        contactNumber: "1234567890",
        email: "john.smith@mayoclinic.com",
        practiceHours: [
            {day: "Monday", startTime: "09:00", endTime: "17:00"},
            {day: "Wednesday", startTime: "09:00", endTime: "17:00"}
        ]
    };

    Physician physician2 = {
        id: "PHY002",
        firstName: "Sarah",
        lastName: "Johnson",
        speciality: "Pediatrics",
        contactNumber: "0987654321",
        email: "sarah.johnson@mayoclinic.com",
        practiceHours: [
            {day: "Tuesday", startTime: "10:00", endTime: "18:00"},
            {day: "Thursday", startTime: "10:00", endTime: "18:00"}
        ]
    };

    physicianTable.add(physician1);
    physicianTable.add(physician2);
}

service / on new http:Listener(8081) {
    // Get all physicians
    resource function get physicians() returns Physician[] {
        return physicianTable.toArray();
    }

    // Get physician by ID
    resource function get physicians/[string physicianId]() returns Physician|http:NotFound {
        Physician? physician = physicianTable[physicianId];
        if physician is () {
            return http:NOT_FOUND;
        }
        return physician;
    }

    // Add new physician
    resource function post physicians(@http:Payload Physician physician) returns Physician|http:BadRequest {
        error? addResult = trap physicianTable.add(physician);
        if addResult is error {
            return http:BAD_REQUEST;
        }
        return physician;
    }

    // Update physician
    resource function put physicians/[string physicianId](@http:Payload Physician physician) returns Physician|http:NotFound {
        Physician? existingPhysician = physicianTable[physicianId];
        if existingPhysician is () {
            return http:NOT_FOUND;
        }
        physicianTable.put(physician);
        return physician;
    }

    // Delete physician
    resource function delete physicians/[string physicianId]() returns http:Ok|http:NotFound {
        Physician? existingPhysician = physicianTable[physicianId];
        if existingPhysician is () {
            return http:NOT_FOUND;
        }
        _ = physicianTable.remove(physicianId);
        return http:OK;
    }
}