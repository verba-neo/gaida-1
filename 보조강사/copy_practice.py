lst_original = ['a', 'b', 'c']

lst2 = ['a', 'b', 'c']

lst3 = lst_original

# 얕은 복사
lst_shallow = lst_original[:]

mat_original = [
    ['a', 'b', 'c'],
    ['d', 'e', 'f'],
    ['g', 'h', 'i'],
]

mat2 = mat_original
mat_shallow = mat_original[:]

mat_original[0][0] = 100


print(mat_original)
print(mat_shallow)