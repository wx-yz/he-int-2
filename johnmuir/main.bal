import ballerina/http;

// Sample data store
table<Physician> key(id) physicianTable = table [
    {
        id: "PHY001",
        firstName: "Michael",
        lastName: "Chen",
        speciality: "Neurology",
        contactNumber: "1234567890",
        email: "michael.chen@johnmuir.com",
        practiceHours: [
            {day: "Monday", startTime: "07:30", endTime: "15:30"},
            {day: "Thursday", startTime: "13:00", endTime: "21:00"},
            {day: "Friday", startTime: "08:00", endTime: "16:00"}
        ]
    },
    {
        id: "PHY002",
        firstName: "Elena",
        lastName: "Rodriguez",
        speciality: "Orthopedics",
        contactNumber: "0987654321",
        email: "elena.rodriguez@johnmuir.com",
        practiceHours: [
            {day: "Tuesday", startTime: "10:00", endTime: "18:00"},
            {day: "Wednesday", startTime: "07:00", endTime: "15:00"},
            {day: "Saturday", startTime: "09:00", endTime: "13:00"}
        ]
    }
];

service / on new http:Listener(8082) {
    resource function get physicians() returns Physician[] {
        return physicianTable.toArray();
    }

    resource function get physicians/[string id]() returns Physician|http:NotFound {
        Physician? physician = physicianTable[id];
        if physician is () {
            return http:NOT_FOUND;
        }
        return physician;
    }

    resource function post physicians(@http:Payload PhysicianRequest physicianRequest) returns Physician {
        string id = "PHY" + (physicianTable.length() + 1).toString().padZero(3);
        Physician physician = {id: id, ...physicianRequest};
        physicianTable.add(physician);
        return physician;
    }

    resource function put physicians/[string id](@http:Payload PhysicianRequest physicianRequest) returns Physician|http:NotFound {
        Physician? existingPhysician = physicianTable[id];
        if existingPhysician is () {
            return http:NOT_FOUND;
        }
        Physician physician = {id: id, ...physicianRequest};
        physicianTable.put(physician);
        return physician;
    }

    resource function delete physicians/[string id]() returns http:Ok|http:NotFound {
        Physician? physician = physicianTable[id];
        if physician is () {
            return http:NOT_FOUND;
        }
        _ = physicianTable.remove(id);
        return http:OK;
    }
}