pragma solidity >=0.4.22 <=0.8.2;
pragma experimental ABIEncoderV2;

contract Owned {
    address payable private owner;
    
    constructor() public {
        owner = msg.sender;
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
    enum RequestType {NewHome, EditHome}
    address[] requestInitiator;
    uint private reqCount;

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
        uint256 area;
        uint256 cost;
    }

    struct Request {
        RequestType requestType;
        string homeAddress;
        uint256 homeArea;
        uint256 homeCost;
        address adr;
        uint256 result;
        bool isProcessed;
    }

    struct Employee {
        string name;
        string position;
        string phoneNumber;
        bool isSet;
    }

    // ================= methods ===================
    function AddHome(
        string memory adr,
        uint256 area,
        uint256 cost
    ) public onlyEmployee {
        Home memory h;
        h.homeAddress = adr;
        h.area = area;
        h.cost = cost;
        homes[adr] = h;
    }

    function GetHome(string memory adr)
        public onlyEmployee
        returns (uint256 area, uint256 cost)
    {
        return (homes[adr].area, homes[adr].cost);
    }

    function AddEmployee(
        address empl,
        string memory name,
        string memory position,
        string memory phoneNumber
    ) public onlyOwner {
        Employee memory e;
        e.name = name;
        e.position = position;
        e.phoneNumber = phoneNumber;
        e.isSet = true;
        employees[empl] = e;
    }

    function GetEmployee(address empl)
        public onlyOwner
        returns (string memory name, string memory position, string memory phoneNumber)
    {
        return (employees[empl].name, employees[empl].position, employees[empl].phoneNumber);
    }
    
    function EditEmployee(
        address empl, 
        string memory name, 
        string memory position, 
        string memory phoneNumber
    ) public onlyOwner {
        employees[empl].name = name;
        employees[empl].position = position;
        employees[empl].phoneNumber = phoneNumber;
    }
    
    function DeleteEmployee(address empl)
        public onlyOwner 
        returns (bool)
    {
        if (employees[empl].isSet){
            delete employees[empl];
            return true;
        }
        return false;
    }
    
    function AddNewHomeRequest(
        string memory homeAddress,
        uint256 homeArea,
        uint256 homeCost
    ) public costs(1e12) payable returns (bool){
        Request memory r;
        r.requestType = RequestType.NewHome;
        r.homeAddress = homeAddress;
        r.homeArea = homeArea;
        r.homeCost = homeCost;
        r.result = 0;
        r.adr = address(0);
        r.isProcessed = false;
        requests[msg.sender] = r;
        requestInitiator.push(msg.sender);
        reqCount += msg.value;
        return true;
    }
    
    function GetRequestsList()
        public onlyEmployee
        returns (Request[] memory request)
    {
        request = new Request[](reqCount);
        
        for (uint _i = 0; _i < reqCount; _i++){
            request[_i] = requests[requestInitiator[_i]];
        }
        
        return request;
    }
    
    // function GetRequestsList()
    //     public onlyEmployee
    //     returns (string[] memory reqType, string[] memory homeAddress, uint256[] memory homeArea, uint256[] memory homeCost)
    // {
    //     reqType = new string[](reqCount);
    //     homeAddress = new string[](reqCount);
    //     homeArea = new uint256[](reqCount);
    //     homeCost = new uint256[](reqCount);
        
    //     for (uint _i = 0; _i < reqCount; _i++){
    //         reqType[_i] = requests[_i].requestType == RequestType.NewHome ? 'NewHome' : 'EditHome';
    //         homeAddress[_i] = requests[_i].homeAddress;
    //         homeArea[_i] = requests[_i].homeArea;
    //         homeCost[_i] = requests[_i].homeCost;
    //         // homeAddress[_i] = requests[_i].home.homeAddress;
    //         // homeArea[_i] = requests[_i].home.area;
    //         // homeCost[_i] = requests[_i].home.cost;
    //     }
        
    //     return (reqType, homeAddress, homeArea, homeCost);
    // }
}

