
public function pagination_values(int count, int page, int _limit) returns int[] {
    if (count == 0) {
        return [0, 0];
    }

    if (page < 1) {
        return [0, 0];
    }

    if (_limit < 1) {
        return [0, 0];
    }

    int _start = (page - 1) * _limit;

    if (_start >= count) {
        return [0, 0];
    }

    int _end = _start + _limit;

    if (_end > count) {
        _end = count;
    }

    return [_start, _end];
}

public function paginateArray(anydata[] array, int page, int _limit) returns anydata[] {
    int offset = (page - 1) * _limit;
    
    if (_limit <= 0 || offset < 0) {
        return [];
    }

    int totalLength = array.length();

    // If offset is out of bounds, return an empty array
    if (offset >= totalLength) {
        return [];
    }

    // Calculate the end index for slicing
    int endIndex = offset + _limit;
    if (endIndex > totalLength) {
        endIndex = totalLength;
    }

    // Return the sliced portion of the array
    return array.slice(offset, endIndex);
}
