pragma solidity >=0.4.22 <=0.8.2;
pragma experimental ABIEncoderV2;

contract Owned {
    address payable private owner;
    
    constructor() public {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner {
        require(
            msg.sender == owner,
            'Only owner can run this function!'
        );
        _;
    }
    
    function ChangeOwner(address payable newOwner) public onlyOwner {
        owner = newOwner;
    }
    
    function GetOwner() public returns (address){
        return owner;
    }
}

contract ROSReestr is Owned {
    
    // ================= variables =================
    enum RequestType { NewHome, EditHome }
    enum OwnerOp { NewOwner, ChangeOwner, AddOwner }
    address[] requestInitiator;
    address[] ownerInitiator;
    string[] homeInitiator;
    uint private reqCount;
    uint private transactCost;
    
    constructor() public {
        transactCost = 100 gwei;
    }

    // ================= mappings ==================
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    // ================= modifiers =================
    modifier onlyEmployee {
        require(
            employees[msg.sender].isSet,
            'Only Employee can run this function!'
        );
        _;
    }
    
    modifier costs(uint value){
        require(
            msg.value >= value,
            'Not enough funds!!'
        );
        _;
    }

    // ================= structs ===================
    struct Ownership {
        string homeAddress;
        address owner;
        uint256 p;
    }

    struct Owner {
        string name;
        uint256 passSer;
        uint256 passNum;
        string passDate;
        string phoneNumber;
    }

    struct Home {
        string homeAddress;
        uint area;
        uint32 cost;
        bool isSet;
    }

    struct Request {
        RequestType requestType;
        string homeAddress;
        uint homeArea;
        uint32 homeCost;
        address adr;
        // uint256 result;
        // bool isProcessed;
    }

    struct Employee {
        string name;
        string position;
        string phoneNumber;
        bool isSet;
    }

    // ================= methods ===================
    
    // === home ===
    function AddHome(
        string memory adr,
        uint area,
        uint32 cost
    ) public 
    {
        Home memory h;
        h.homeAddress = adr;
        h.area = area;
        h.cost = cost;
        h.isSet = true;
        homes[adr] = h;
        homeInitiator.push(adr);
    }
    
    function GetHome(string memory adr) public returns (Home memory)
    {
        return homes[adr];
    }
    
    function GetHomeList() public returns (Home[] memory homesList) 
    {
        homesList = new Home[](homeInitiator.length);
        
        for(uint _i = 0; _i < homeInitiator.length; _i++){
            homesList[_i] = homes[homeInitiator[_i]];
        }
            
        return homesList;
    }
    
    // === owner ===
    // function AddOwnership(uint count, address owner, uint256 p) public {
    //     Ownership[] o = new Ownership[](count);
        
    // }
    
    function GetOwnerList() public returns (Owner[] memory ownersList)
    {
        ownersList = new Owner[](ownerInitiator.length);
        
        for(uint _i = 0; _i < ownerInitiator.length; _i++){
            ownersList[_i] = owners[ownerInitiator[_i]];
        }
        
        return ownersList;
    }

    // === employee ===
    function AddEmployee(
        address empl,
        string memory name,
        string memory position,
        string memory phoneNumber
    ) public onlyOwner 
    {
        Employee memory e;
        e.name = name;
        e.position = position;
        e.phoneNumber = phoneNumber;
        e.isSet = true;
        employees[empl] = e;
    }

    function GetEmployee(address empl) public onlyOwner
        returns (string memory name, string memory position, string memory phoneNumber)
    {
        return (employees[empl].name, employees[empl].position, employees[empl].phoneNumber);
    }
    
    function EditEmployee(
        address empl, 
        string memory name, 
        string memory position, 
        string memory phoneNumber
    ) public onlyOwner
    {
        employees[empl].name = name;
        employees[empl].position = position;
        employees[empl].phoneNumber = phoneNumber;
    }
    
    function DeleteEmployee(address empl) public onlyOwner returns (bool)
    {
        if (employees[empl].isSet){
            delete employees[empl];
            return true;
        }
        return false;
    }
    
    // === request ===
    function AddNewHomeRequest(
        string memory homeAddress,
        uint homeArea,
        uint32 homeCost
    ) public costs(transactCost) payable returns (bool)
    {
        Request memory r;
        r.requestType = RequestType.NewHome;
        r.homeAddress = homeAddress;
        r.homeArea = homeArea;
        r.homeCost = homeCost;
        //r.result = 0;
        r.adr = address(0);
        //r.isProcessed = false;
        requests[msg.sender] = r;
        requestInitiator.push(msg.sender);
        reqCount += msg.value;
        return true;
    }
    
    function AddEditHomeRequest(
        string memory homeAddress,
        uint homeArea,
        uint32 homeCost
        ) public costs(transactCost) payable returns (bool)
    {
        Request memory r;
        r.requestType = RequestType.EditHome;
        r.homeAddress = homeAddress;
        r.homeArea = homeArea;
        r.homeCost = homeCost;
        r.adr = address(0);
        requests[msg.sender] = r;
        requestInitiator.push(msg.sender);
        reqCount += msg.value;
        return true;
    }
    
    function AddOwnerRequest() public costs(transactCost) payable returns (bool) 
    {
        // . . .
        ownerInitiator.push(msg.sender);
        return true;
    }
    
    function GetRequestList() public onlyEmployee returns (Request[] memory request)
    {
        request = new Request[](reqCount);
        
        for (uint _i = 0; _i < reqCount; _i++){
            request[_i] = requests[requestInitiator[_i]];
        }
        
        return request;
    }
    
    function ProcessRequest(uint id) public onlyEmployee costs(transactCost) payable returns (uint) 
    {
        if (id < 0 || id >= requestInitiator.length)
            return 1;
        Request memory r = requests[requestInitiator[id]];
        if (r.requestType == RequestType.NewHome && homes[r.homeAddress].isSet){
            delete requests[requestInitiator[id]];
            delete requestInitiator[id];
            return 2;
        }
        if (r.requestType == RequestType.NewHome){
           //add new Home
            AddHome(r.homeAddress, r.homeArea, r.homeCost);
            //set ownership
            Ownership memory ownership;
            ownership.homeAddress = r.homeAddress;
            ownership.owner = requestInitiator[id];
            ownership.p = 1;
            ownerships[r.homeAddress].push(ownership);
        } 
        if (r.requestType == RequestType.EditHome){
            // edit home
            homes[r.homeAddress].area = r.homeArea;
            homes[r.homeAddress].cost = r.homeCost;
            // change ownership
            // . . .
        }
        delete requests[requestInitiator[id]];
        delete requestInitiator[id];
        return 0;
    }
    
    function GetPrice() public returns (uint price)
    {
        return transactCost;
    }
}
