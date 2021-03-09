contract Test
{
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
        Owner owner;
    }
    struct Request
    {
        int _type;
        Home home;
        int result;
    }
    struct Employee
    {
        string nameEmployee;
        string position;
        string phone_numberEmployee;
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
