return function(odds: number, rolls: number): boolean
    return math.random() < 1 - (1 - odds) ^ rolls
end
