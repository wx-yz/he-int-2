type TimeSlot record {|
    string day;
    string startTime;
    string endTime;
|};

type Physician record {|
    readonly string id;
    string firstName;
    string lastName;
    string speciality;
    string contactNumber;
    string email;
    TimeSlot[] practiceHours;
|};