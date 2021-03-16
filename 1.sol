pragma solidity >=0.4.22 <0.6.0;

contract Owned {
    address private owner;
    
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
    
    function ChangeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
    function GetOwner() public returns (address){
        return owner;
    }
}

contract ROSReestr is Owned {
    enum RequestType {NewHome, EditHome}

    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    modifier onlyEmployee {
        require(
            employees[msg.sender].isSet,
            'Only Employee can run this function!'
        );
        _;
    }

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
        Home home;
        uint256 result;
    }

    struct Employee {
        string name;
        string position;
        string phoneNumber;
        bool isSet;
    }

    function AddHome(
        string memory adr,
        uint256 area,
        uint256 cost
    ) public {
        Home memory h;
        h.homeAddress = adr;
        h.area = area;
        h.cost = cost;
        homes[adr] = h;
    }

    function GetHome(string memory adr)
        public
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
}
