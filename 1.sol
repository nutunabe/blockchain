pragma solidity >=0.4.22 <0.6.0;

contract Test {
    enum RequestType {NewHome, EditHome}

    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;

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
}
