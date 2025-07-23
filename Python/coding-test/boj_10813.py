# boj_10813.py
N, M = map(int, input().split())

basket = [i for i in range(1, N+1)]

for _ in range(M):
    i, j = map(int, input().split())
    i -= 1
    j -= 1
    
    basket[i], basket[j] = basket[j], basket[i]

# print(' '.join(map(str, basket)))
print(*basket)
