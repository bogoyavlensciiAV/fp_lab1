def solve(file_name):
    f = open(file_name, encoding="utf-8")
    data = f.read()
    f.close()

    names = sorted(name.strip('"') for name in data.split(','))

    total = 0
    for i, name in enumerate(names, 1):
        score = sum(ord(c) - ord('A') + 1 for c in name)
        total += score * i

    return total