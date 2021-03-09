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

    Home private home;
    Owner private owner;
    Request private request;
    Employee private employee;

    string private message;

    function Test1(string memory Message) public 
    {
        message = Message;
    }

    function SetMessage(string memory newMessage) public
    {
        message = newMessage;
    }

    function GetMessage() public returns (string memory)
    {
        return message;
    }
}
