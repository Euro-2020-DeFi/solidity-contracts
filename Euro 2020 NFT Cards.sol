// Dependency file: contracts/interfaces/IERC165.sol

// pragma solidity ^0.6.0;
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// Dependency file: contracts/interfaces/IERC20.sol

// pragma solidity ^0.6.0;
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function mint(address account, uint256 amount) external;

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Dependency file: contracts/libraries/ERC165.sol

// import '../interfaces/IERC165.sol';
// pragma solidity ^0.6.0;
contract ERC165 is IERC165 {
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor() internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, 'ERC165: invalid interface id');
        _supportedInterfaces[interfaceId] = true;
    }
}

// Dependency file: contracts/interfaces/IERC721.sol

// pragma solidity ^0.6.2;
// import './IERC165.sol';
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

// Dependency file: contracts/libraries/Strings.sol

// pragma solidity ^0.6.0;
library Strings {
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return '0';
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = bytes1(uint8(48 + (temp % 10)));
            temp /= 10;
        }
        return string(buffer);
    }
}

// Dependency file: contracts/libraries/EnumerableMap.sol

// pragma solidity ^0.6.0;
library EnumerableMap {
    struct MapEntry {
        bytes32 _key;
        bytes32 _value;
    }
    struct Map {
        MapEntry[] _entries;
        mapping(bytes32 => uint256) _indexes;
    }

    function _set(
        Map storage map,
        bytes32 key,
        bytes32 value
    ) private returns (bool) {
        uint256 keyIndex = map._indexes[key];
        if (keyIndex == 0) {
            map._entries.push(MapEntry({_key: key, _value: value}));
            map._indexes[key] = map._entries.length;
            return true;
        } else {
            map._entries[keyIndex - 1]._value = value;
            return false;
        }
    }

    function _remove(Map storage map, bytes32 key) private returns (bool) {
        uint256 keyIndex = map._indexes[key];
        if (keyIndex != 0) {
            uint256 toDeleteIndex = keyIndex - 1;
            uint256 lastIndex = map._entries.length - 1;
            MapEntry storage lastEntry = map._entries[lastIndex];
            map._entries[toDeleteIndex] = lastEntry;
            map._indexes[lastEntry._key] = toDeleteIndex + 1;
            map._entries.pop();
            delete map._indexes[key];
            return true;
        } else {
            return false;
        }
    }

    function _contains(Map storage map, bytes32 key) private view returns (bool) {
        return map._indexes[key] != 0;
    }

    function _length(Map storage map) private view returns (uint256) {
        return map._entries.length;
    }

    function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
        require(map._entries.length > index, 'EnumerableMap: index out of bounds');
        MapEntry storage entry = map._entries[index];
        return (entry._key, entry._value);
    }

    function _get(Map storage map, bytes32 key) private view returns (bytes32) {
        return _get(map, key, 'EnumerableMap: nonexistent key');
    }

    function _get(
        Map storage map,
        bytes32 key,
        string memory errorMessage
    ) private view returns (bytes32) {
        uint256 keyIndex = map._indexes[key];
        require(keyIndex != 0, errorMessage);
        return map._entries[keyIndex - 1]._value;
    }

    struct UintToAddressMap {
        Map _inner;
    }

    function set(
        UintToAddressMap storage map,
        uint256 key,
        address value
    ) internal returns (bool) {
        return _set(map._inner, bytes32(key), bytes32(uint256(value)));
    }

    function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
        return _remove(map._inner, bytes32(key));
    }

    function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
        return _contains(map._inner, bytes32(key));
    }

    function length(UintToAddressMap storage map) internal view returns (uint256) {
        return _length(map._inner);
    }

    function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
        (bytes32 key, bytes32 value) = _at(map._inner, index);
        return (uint256(key), address(uint256(value)));
    }

    function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
        return address(uint256(_get(map._inner, bytes32(key))));
    }

    function get(
        UintToAddressMap storage map,
        uint256 key,
        string memory errorMessage
    ) internal view returns (address) {
        return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
    }
}

// Dependency file: contracts/libraries/EnumerableSet.sol

// pragma solidity ^0.6.0;
library EnumerableSet {
    struct Set {
        bytes32[] _values;
        mapping(bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        uint256 valueIndex = set._indexes[value];
        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;
            bytes32 lastvalue = set._values[lastIndex];
            set._values[toDeleteIndex] = lastvalue;
            set._indexes[lastvalue] = toDeleteIndex + 1;
            set._values.pop();
            delete set._indexes[value];
            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, 'EnumerableSet: index out of bounds');
        return set._values[index];
    }

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }

    struct UintSet {
        Set _inner;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

// Dependency file: contracts/libraries/Address.sol

// pragma solidity ^0.6.2;
library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, 'Address: insufficient balance');
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, 'Address: low-level call failed');
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'Address: insufficient balance for call');
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), 'Address: call to non-contract');
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// Dependency file: contracts/libraries/SafeMath.sol

// pragma solidity ^0.6.0;
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, 'SafeMath: addition overflow');
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, 'SafeMath: subtraction overflow');
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, 'SafeMath: multiplication overflow');
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, 'SafeMath: division by zero');
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, 'SafeMath: modulo by zero');
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// Dependency file: contracts/interfaces/IERC721Receiver.sol

// pragma solidity ^0.6.0;
interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// Dependency file: contracts/interfaces/IERC721Enumerable.sol

// pragma solidity ^0.6.2;
// import './IERC721.sol';
interface IERC721Enumerable is IERC721 {
    function totalSupply() external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) external view returns (uint256);
}

// Dependency file: contracts/interfaces/IERC721Metadata.sol

// pragma solidity ^0.6.2;
// import './IERC721.sol';
interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// Dependency file: contracts/libraries/Context.sol

// pragma solidity ^0.6.0;
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

// Dependency file: contracts/interfaces/INFTsFactory.sol

// pragma solidity ^0.6.12;

interface INFTsFactory {
    function getEuro2020Cards(uint256 tokenId)
        external
        view
        returns (
            bytes32 name,
            uint8 rank,
            bool buyable
        );

    function setEuroCardIndex(
        uint256 tokenId,
        bytes32 name,
        uint8 rank,
        bool buyable
    ) external;
}

// Dependency file: contracts/libraries/ERC20.sol

// pragma solidity ^0.6.0;
// import '../interfaces/IERC20.sol';
// import './Context.sol';
// import './SafeMath.sol';
// import './Address.sol';
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function mint(address account, uint256 amount) public virtual override {
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), 'ERC20: transfer from the zero address');
        require(recipient != address(0), 'ERC20: transfer to the zero address');
        _beforeTokenTransfer(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), 'ERC20: mint to the zero address');
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), 'ERC20: burn from the zero address');
        _beforeTokenTransfer(account, address(0), amount);
        _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), 'ERC20: approve from the zero address');
        require(spender != address(0), 'ERC20: approve to the zero address');
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// Dependency file: contracts/libraries/SafeERC20.sol

// pragma solidity ^0.6.0;
// import './SafeMath.sol';
// import './Address.sol';
// import '../interfaces/IERC20.sol';
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            'SafeERC20: approve from non-zero to non-zero allowance'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance =
            token.allowance(address(this), spender).sub(value, 'SafeERC20: decreased allowance below zero');
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, 'SafeERC20: low-level call failed');
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
        }
    }
}

// Dependency file: contracts/libraries/Euro2020DeFiUtils.sol

// pragma solidity ^0.6.12;
library Euro2020DeFiUtils {
    function uintToString(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return '0';
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }
}

// Dependency file: contracts/libraries/Governance.sol

// pragma solidity ^0.6.12;
contract Governance {
    address public _governance;

    constructor() public {
        _governance = msg.sender;
    }

    event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
    modifier onlyGovernance {
        require(msg.sender == _governance, 'not governance');
        _;
    }

    function setGovernance(address governance) public onlyGovernance {
        require(governance != address(0), 'new governance the zero address');
        emit GovernanceTransferred(_governance, governance);
        _governance = governance;
    }
}

// Dependency file: contracts/libraries/ERC721.sol

// pragma solidity ^0.6.0;
// import './Context.sol';
// import '../interfaces/IERC721Metadata.sol';
// import '../interfaces/IERC721Enumerable.sol';
// import '../interfaces/IERC721Receiver.sol';
// import './SafeMath.sol';
// import './Address.sol';
// import './EnumerableSet.sol';
// import './EnumerableMap.sol';
// import './Strings.sol';
// import '../interfaces/IERC721.sol';
// import './ERC165.sol';
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using Strings for uint256;
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    mapping(address => EnumerableSet.UintSet) private _holderTokens;
    EnumerableMap.UintToAddressMap private _tokenOwners;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    string private _name;
    string private _symbol;
    mapping(uint256 => string) private _tokenURIs;
    string private _baseURI;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _registerInterface(_INTERFACE_ID_ERC721);
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), 'ERC721: balance query for the zero address');
        return _holderTokens[owner].length();
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return _tokenOwners.get(tokenId, 'ERC721: owner query for nonexistent token');
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
        string memory _tokenURI = _tokenURIs[tokenId];
        if (bytes(_baseURI).length == 0) {
            return _tokenURI;
        }
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(_baseURI, _tokenURI));
        }
        return string(abi.encodePacked(_baseURI, tokenId.toString()));
    }

    function baseURI() public view returns (string memory) {
        return _baseURI;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
        return _holderTokens[owner].at(index);
    }

    function _tokensOfOwners(address owner) internal view returns (uint256[] storage) {
        return _ownedTokens[owner];
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }
        _ownedTokens[from].pop();
    }

    function totalSupply() public view override returns (uint256) {
        return _tokenOwners.length();
    }

    function tokenByIndex(uint256 index) public view override returns (uint256) {
        (uint256 tokenId, ) = _tokenOwners.at(index);
        return tokenId;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(to != owner, 'ERC721: approval to current owner');
        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            'ERC721: approve caller is not owner nor approved for all'
        );
        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), 'ERC721: approve to caller');
        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, '');
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _tokenOwners.contains(tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, '');
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            'ERC721: transfer to non ERC721Receiver implementer'
        );
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), 'ERC721: mint to the zero address');
        require(!_exists(tokenId), 'ERC721: token already minted');
        _beforeTokenTransfer(address(0), to, tokenId);
        _holderTokens[to].add(tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
        _tokenOwners.set(tokenId, to);
        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        _beforeTokenTransfer(owner, address(0), tokenId);
        _approve(address(0), tokenId);
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
        _holderTokens[owner].remove(tokenId);
        _tokenOwners.remove(tokenId);
        _removeTokenFromOwnerEnumeration(owner, tokenId);
        _ownedTokensIndex[tokenId] = 0;
        emit Transfer(owner, address(0), tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
        require(to != address(0), 'ERC721: transfer to the zero address');
        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);
        _holderTokens[from].remove(tokenId);
        _holderTokens[to].add(tokenId);
        _removeTokenFromOwnerEnumeration(from, tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
        _tokenOwners.set(tokenId, to);
        emit Transfer(from, to, tokenId);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), 'ERC721Metadata: URI set of nonexistent token');
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _setBaseURI(string memory baseURI_) internal virtual {
        _baseURI = baseURI_;
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (!to.isContract()) {
            return true;
        }
        bytes memory returndata =
            to.functionCall(
                abi.encodeWithSelector(
                    IERC721Receiver(to).onERC721Received.selector,
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                ),
                'ERC721: transfer to non ERC721Receiver implementer'
            );
        bytes4 retval = abi.decode(returndata, (bytes4));
        return (retval == _ERC721_RECEIVED);
    }

    function _approve(address to, uint256 tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

// import '../libraries/ERC721.sol';
// import '../libraries/Governance.sol';
// import '../libraries/Euro2020DeFiUtils.sol';
// import '../libraries/SafeERC20.sol';
// import '../libraries/ERC20.sol';
// import '../interfaces/INFTsFactory.sol';
// import '../libraries/Context.sol';

contract Euro2020NFTsCardToken is Context, ERC721, Governance {
    using SafeERC20 for ERC20;
    using SafeMath for uint256;
    uint256 public constant DURATION = 365 days;
    INFTsFactory public nextFactory;
    ERC20 euroToken;
    event CreateCard(uint256 tokenId, bytes32 name, uint8 rank, uint256 blockNum, address author);
    event GovernanceTransferred(address previousOwner, address newOwner);
    event ReturnCard(uint256 tokenId, bytes32 name, uint8 rank, uint256 blockNum, address author);

    struct TeamCardIndex {
        bytes32 name;
        uint8 rank;
        bool buyable;
    }
    struct PaymentsInfo {
        uint8 teamRanking;
        uint256 amount;
        bytes32 teamName;
        string tokenURI;
    }
    PaymentsInfo[] public paymentsInfo;
    mapping(address => bool) public isContractCaller;
    mapping(address => uint8) public isAirdropWhitelister;
    mapping(uint256 => TeamCardIndex) private cardIndex;
    mapping(address => bool) private _minters;
    uint256 private tokenID = 0;

    constructor(ERC20 _euroToken) public ERC721('Euro 2020 NFT Cards', 'EURO2020') {
        _minters[msg.sender] = true;
        _minters[address(this)] = true;
        euroToken = _euroToken;
        isContractCaller[msg.sender] = true;
        _setBaseURI('https://ipfs.io/ipfs/');

        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 53,
                amount: 1270 * 10**6 * 10**9,
                teamName: 'England',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 79,
                amount: 1030 * 10**6 * 10**9,
                teamName: 'France',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 76,
                amount: 936 * 10**6 * 10**9,
                teamName: 'Germany',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 65,
                amount: 915 * 10**6 * 10**9,
                teamName: 'Spain',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );

        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 69,
                amount: 872 * 10**6 * 10**9,
                teamName: 'Portugal',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 77,
                amount: 771 * 10**6 * 10**9,
                teamName: 'Italy',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 92,
                amount: 669 * 10**6 * 10**9,
                teamName: 'Belgium',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 74,
                amount: 607 * 10**6 * 10**9,
                teamName: 'Netherlands',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );

        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 78,
                amount: 375 * 10**6 * 10**9,
                teamName: 'Croatia',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 50,
                amount: 325 * 10**6 * 10**9,
                teamName: 'Turkey',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 75,
                amount: 320 * 10**6 * 10**9,
                teamName: 'Austria',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 68,
                amount: 310 * 10**6 * 10**9,
                teamName: 'Denmark',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );

        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 70,
                amount: 283 * 10**6 * 10**9,
                teamName: 'Switzerland',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 73,
                amount: 269 * 10**6 * 10**9,
                teamName: 'Scotland',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 71,
                amount: 254 * 10**6 * 10**9,
                teamName: 'Poland',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 93,
                amount: 215 * 10**6 * 10**9,
                teamName: 'Sweden',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );

        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 64,
                amount: 197 * 10**6 * 10**9,
                teamName: 'Ukraine',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 72,
                amount: 191 * 10**6 * 10**9,
                teamName: 'Russia',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 66,
                amount: 190 * 10**6 * 10**9,
                teamName: 'Czech Republic',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 56,
                amount: 176 * 10**6 * 10**9,
                teamName: 'Wales',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );

        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 82,
                amount: 131 * 10**6 * 10**9,
                teamName: 'Slovakia',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 81,
                amount: 74 * 10**6 * 10**9,
                teamName: 'Hungary',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 87,
                amount: 62 * 10**6 * 10**9,
                teamName: 'North Macedonia',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
        paymentsInfo.push(
            PaymentsInfo({
                teamRanking: 80,
                amount: 44 * 10**6 * 10**9,
                teamName: 'Finland',
                tokenURI: 'QmUY7KFVvJcbNc8fWhVHdm8pYRcEajuFz9EFGmRBn6ARwg'
            })
        );
    }

    modifier onlyContractCaller() {
        require(isContractCaller[msg.sender], 'not call by contract');
        _;
    }

    modifier checkEuroEnd() {
        require(block.timestamp < 1626038460, 'EUFA Euro 2020 has ended');
        _;
    }

    modifier checkAirdropWhitelist() {
        require(isAirdropWhitelister[msg.sender] > 0, 'User is not in this list');
        _;
    }

    function setContractCaller(address _caller) external onlyGovernance {
        require(_caller != address(0), 'cannot called by address zero');
        isContractCaller[_caller] = true;
    }

    function setAirdropWhitelist(address[] calldata _list, uint8[] calldata _rank) external onlyGovernance {
        require(_list.length > 0, 'empty list');
        for (uint256 i = 0; i < _list.length; i++) {
            isAirdropWhitelister[_list[i]] = _rank[i];
        }
    }

    function addPayment(
        uint8 _teamRanking,
        uint256 _amount,
        bytes32 _teamName,
        string memory _tokenURI
    ) public onlyGovernance {
        paymentsInfo.push(
            PaymentsInfo({teamRanking: _teamRanking, amount: _amount, teamName: _teamName, tokenURI: _tokenURI})
        );
    }

    function editPayment(
        uint256 _pid,
        uint256 _amount,
        string memory _tokenURI
    ) public onlyGovernance {
        paymentsInfo[_pid].amount = _amount;
        paymentsInfo[_pid].tokenURI = _tokenURI;
    }

    function getEuro2020Cards(uint256 tokenid)
        public
        view
        returns (
            bytes32,
            uint8,
            bool
        )
    {
        bytes32 _name = cardIndex[tokenid].name;
        uint8 _rank = cardIndex[tokenid].rank;
        bool _buyable = cardIndex[tokenid].buyable;
        if (_buyable == false && nextFactory != INFTsFactory(0x0))
            (_name, _rank, _buyable) = nextFactory.getEuro2020Cards(tokenid);
        return (_name, _rank, _buyable);
    }

    function setNextFactory(INFTsFactory factory) public onlyGovernance {
        require(factory != INFTsFactory(0x0), 'set factory by non contract');
        nextFactory = factory;
    }

    function getPayment(uint8 _pRank) public view returns (uint256) {
        for (uint256 i = 0; i < paymentsInfo.length; i++) {
            if (paymentsInfo[i].teamRanking == _pRank) return paymentsInfo[i].amount;
        }
        return 0;
    }

    function getTeamName(uint8 _pRank) internal view returns (bytes32) {
        for (uint256 i = 0; i < paymentsInfo.length; i++) {
            if (paymentsInfo[i].teamRanking == _pRank) return paymentsInfo[i].teamName;
        }
        return 0x0;
    }

    function forwardFund(uint256 _value) private {
        payable(_governance).transfer(_value);
    }

    function random1(uint16 num) private view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % num);
    }

    function random2(uint16 num) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, now))) % num;
    }

    receive() external payable {
        createCard(53);
    }

    function _setEuroCardIndex(
        uint256 _tokenId,
        bytes32 _name,
        uint8 _rank,
        bool _buyable
    ) internal {
        cardIndex[_tokenId].name = _name;
        cardIndex[_tokenId].rank = _rank;
        cardIndex[_tokenId].buyable = _buyable;
        string memory _tokenURI = '0x0';
        for (uint256 i = 0; i < paymentsInfo.length; i++)
            if (_rank == paymentsInfo[i].teamRanking) _tokenURI = paymentsInfo[i].tokenURI;
        _setTokenURI(_tokenId, _tokenURI);
    }

    function setEuroCardIndex(
        uint256 _tokenId,
        bytes32 _name,
        uint8 _rank,
        bool _buyable
    ) external onlyContractCaller {
        _setEuroCardIndex(_tokenId, _name, _rank, _buyable);
    }

    function setURIPrefix(string memory baseURI) public onlyGovernance {
        _setBaseURI(baseURI);
    }

    function mint(address to, uint256 tokenId) external returns (bool) {
        require(_minters[msg.sender], '!minter');
        _mint(to, tokenId);
        //_setTokenURI(tokenId, paymentsInfo[]);
        return true;
    }

    function safeMint(address to, uint256 tokenId) public returns (bool) {
        require(_minters[msg.sender], '!minter');
        _safeMint(to, tokenId);
        //_setTokenURI(tokenId, Euro2020DeFiUtils.uintToString(tokenId));
        return true;
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public returns (bool) {
        require(_minters[msg.sender], '!minter');
        _safeMint(to, tokenId, _data);
        //_setTokenURI(tokenId, Euro2020DeFiUtils.uintToString(tokenId));
        return true;
    }

    function addMinter(address minter) public onlyGovernance {
        _minters[minter] = true;
    }

    function removeMinter(address minter) public onlyGovernance {
        _minters[minter] = false;
    }

    function burn(uint256 tokenId) external {
        require(_minters[msg.sender], '!minter');
        require(_isApprovedOrOwner(_msgSender(), tokenId), 'caller is not owner nor approved');
        _burn(tokenId);
    }

    function tokensOfOwner(address owner) public view returns (uint256[] memory) {
        return _tokensOfOwners(owner);
    }

    function euroCardGeneration(
        address[] calldata _investors,
        uint256[] calldata _tokenIds,
        bytes32 _name,
        uint8 _rank,
        bool _flags
    ) external onlyGovernance {
        require(_investors.length == _tokenIds.length, 'lenght not match');
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            this.mint(_investors[i], _tokenIds[i]);
            _setEuroCardIndex(_tokenIds[i], _name, _rank, _flags);
        }
    }

    function claimAirdrop() public checkAirdropWhitelist {
        uint8 _rank = isAirdropWhitelister[msg.sender];
        uint256 _tokenId = ((block.timestamp * 10) + random1(9) + 1) * 100 + _rank;
        bytes32 _name = getTeamName(_rank);
        bool _buyable = false;
        this.mint(msg.sender, _tokenId);
        _setEuroCardIndex(_tokenId, _name, _rank, _buyable);
    }

    function createCard(uint8 _rank) public payable {
        uint256 payAmount = getPayment(_rank);
        uint256 _tokenId = ((block.timestamp * 10) + random1(9) + 1) * 100 + _rank;
        bytes32 _name = getTeamName(_rank);
        bool _buyable = false;
        require(euroToken.balanceOf(msg.sender) >= payAmount, 'token balance not enough');
        euroToken.transferFrom(msg.sender, address(this), payAmount);
        _buyable = true;
        this.mint(msg.sender, _tokenId);
        emit CreateCard(_tokenId, _name, _rank, block.number, msg.sender);
        _setEuroCardIndex(_tokenId, _name, _rank, _buyable);
    }

    function returnCard(uint256 tokenId) public checkEuroEnd {
        require(msg.sender == this.ownerOf(tokenId), 'ownerOf nft tokens fail');
        bytes32 _name;
        uint8 _rank;
        bool _buyable;
        (_name, _rank, _buyable) = getEuro2020Cards(tokenId);
        require(_buyable, 'Airdrop NFT cannot be sold');
        uint256 _paymentMethod = getPayment(_rank);
        require(euroToken.balanceOf(address(this)) >= _paymentMethod, 'token balance not enough');
        euroToken.transferFrom(address(this), msg.sender, _paymentMethod);
        this.safeTransferFrom(msg.sender, address(this), tokenId);
        this.burn(tokenId);
        emit ReturnCard(tokenID, _name, _rank, block.number, msg.sender);
    }
}
