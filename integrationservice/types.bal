type PracticeHours record {|
    string day;
    string startTime;
    string endTime;
|};

type Physician record {|
    string id;
    string firstName;
    string lastName;
    string speciality;
    string contactNumber;
    string email;
    PracticeHours[] practiceHours;
|};

type PhysicianResponse record {|
    Physician[] physicians;
|};