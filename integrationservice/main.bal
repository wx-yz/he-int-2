import ballerina/http;
import ballerina/os;

final string hospital1Url = os:getEnv("HOSPITAL1_URL");
final string hospital2Url = os:getEnv("HOSPITAL2_URL");

final http:Client hospital1Client = check new (hospital1Url);
final http:Client hospital2Client = check new (hospital2Url);

service / on new http:Listener(8080) {
    resource function get physicians/[string speciality]() returns Physician[]|error {
        Physician[] hospital1Physicians = check hospital1Client->/physicians();
        Physician[] hospital2Physicians = check hospital2Client->/physicians();

        Physician[] allPhysicians = [...hospital1Physicians, ...hospital2Physicians];
        return from Physician physician in allPhysicians
            where physician.speciality == speciality
            select physician;
    }
}