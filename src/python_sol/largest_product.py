def solve(number, l):
    if len(number) < l:
        return "Error: 'l' must be less than or equal to the length of the number"
    if l <= 0:
        return "Error: 'l' must be positive"
    
    mul_dict = {n : 1 for n in range(len(number)-l+1)}

    for idx, char in enumerate(number):
        for i in range(l):
            if 0 <= idx-i <=  len(number)-l:
                try:
                    digit = int(char)
                except ValueError:
                    return f"Error: Can't parse: \"{char}\""
                mul_dict[idx-i] *= int(char)

    return max(mul_dict.values())