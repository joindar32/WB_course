// Задача:
// Дан слайс
// Необходимо заменить четные числа на 1 и посчитать сумму чисел в новом слайсе
// numbers := []int{3, 5, 7, 2, 7, 8, 6, 4, 7, 0, 1, 7, 4, 8, 10, 3, 6, 8, 5, 4, 12, 3}

package main

import (
	"fmt"
	"math"
)

func main() {
	numbers := []int{3, 5, 7, 2, 7, 8, 6, 4, 7, 0, 1, 7, 4, 8, 10, 3, 6, 8, 5, 4, 12, 3}
	fmt.Println(numbers)

	sum := 0
	for index := range numbers {
		if numbers[index]%2 == 0 {
			numbers[index] = 1
			sum += 1
		} else {
			sum += numbers[index]
		}
	}
	fmt.Println("Ответ на первую задачу:")
	fmt.Println(sum)
	fmt.Println(numbers)

	// Задача:
	// Создайте слайс целых чисел и заполните его числами от 1 до 10.
	// Используя цикл, пройдите по слайсу и увеличьте каждое значение на 5, используя указатель.
	// Выведите измененный слайс.

	slice := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	for index := range slice {
		ptr := &slice[index]
		*ptr += 5
	}
	fmt.Println("Ответ на вторую задачу:")
	fmt.Println(slice)

	// Задача:
	// Дан слайс чисел, необходимо найти минимальное и максимальное значение, которое делится на 2 без остатка.
	numbers2 := []int{8, 44, 3, 5, 11, 8, 2, 10, 6, 77, 15, 12}

	min := math.MaxInt
	max := math.MinInt
	found := false
	for _, value := range numbers2 {
		if value % 2 == 0 {
			found = true
			if value < min {
				min = value
			}
			if value > max {
				max = value
			}
		}
		
	}
	
	fmt.Println("Ответ на третью задачу:")
	if found{
		fmt.Printf("Min: %d\n", min)
		fmt.Printf("Max: %d\n", max)
	} else{
		fmt.Println("Нет четных чисел")
	}
	


}
