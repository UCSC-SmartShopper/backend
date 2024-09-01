
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
