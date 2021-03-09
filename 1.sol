pragma solidity >=0.4.22 <0.6.0;

contract Test
{
    enum RequestType {NewHome, EditHome}
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;

    struct Owner
    {
        string name;
        int pass_ser;
        int pass_num;
        string phone_number;
        uint256 pass_date;
    }
    struct Home
    {
        string Address;
        fixed Area;
        int Cost;
        address owner;
    }
    struct Request
    {
        RequestType requestType;
        Home home;
        int result;
        address adr;
    }
    struct Employee
    {
        string nameEmployee;
        int position;
        int phone_numberEmployee;
    }

    function AddHome(string memory _adr, uint _area, uint _cost) public
    {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public returns(uint _area, uint _cost)
    {
        return (homes[adr].area, homes[adr].cost);
    }
}
