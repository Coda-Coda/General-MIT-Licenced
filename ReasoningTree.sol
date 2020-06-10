pragma solidity >=0.5.7 <0.6.0;

// Facilitates a tree of points with pros and cons where only additions to the 'reasoning tree' can be made.
contract ReasoningTree {

    struct Node { // Point/Idea/Content
        string keyIdea;
        string moreDetail;
        address author;
        uint[] pros;
        uint[] cons;
    }
    
    mapping(uint => Node) nodes;
    uint nextId;
    event ReturnValue(address indexed _from, uint thisNodeId);

    constructor() public {
        nextId = 1; // Node Ids start from 1
    }

    // Sets the required details of the next node
    function setNextNodeDetails(uint thisNodeId, string memory newKeyIdea, string memory newMoreDetail, address author) private {
        nodes[thisNodeId].keyIdea = newKeyIdea;
        nodes[thisNodeId].moreDetail = newMoreDetail;
        nodes[thisNodeId].author = author;
    }

    // Add a Node/Point/Idea that is not linked to any parent Node
    function addNewTopic(string memory newKeyIdea, string memory newMoreDetail) public returns (uint thisNodeId) {
        thisNodeId = nextId;
        setNextNodeDetails(thisNodeId, newKeyIdea, newMoreDetail, msg.sender);
        nextId = nextId + 1;
        emit ReturnValue(msg.sender, thisNodeId);
        return thisNodeId;
    }
    
    // Add a Node/Point/Idea that is either a pro or con of another Node
    function add(string memory newKeyIdea, string memory newMoreDetail, uint parent, bool supportsParent) public returns (uint thisNodeId) {
        require(parent < nextId);
        thisNodeId = nextId;
        setNextNodeDetails(thisNodeId, newKeyIdea, newMoreDetail, msg.sender);
        if (supportsParent)
            nodes[parent].pros.push(thisNodeId);
        else
            nodes[parent].cons.push(thisNodeId);
        nextId = nextId + 1;
        emit ReturnValue(msg.sender, thisNodeId);
        return thisNodeId;
    }
    
    // Retrieve the details about a given Node
    function retrieve (uint nodeId) public view returns (string memory, string memory, address, uint[] memory, uint[] memory)  {
        require(nodeId < nextId);
        return (nodes[nodeId].keyIdea, nodes[nodeId].moreDetail, nodes[nodeId].author, nodes[nodeId].pros, nodes[nodeId].cons);
    }
    
    // Get the key idea of a given node
    function getKeyIdea(uint nodeId) public view returns (string memory) {
        return nodes[nodeId].keyIdea;
    }
    
    // Get the current node count. NodeIds from 1 up to and including the node count will hold data.
    function nodeCount() public view returns (uint) {
        return nextId - 1; // NodeIds start from one, so the count of current nodes is 1 less than nextId.
    }
}
