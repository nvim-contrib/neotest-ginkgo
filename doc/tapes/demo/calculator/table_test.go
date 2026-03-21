package calculator_test

import (
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"demo/calculator"
)

var _ = Describe("Calculator (table)", func() {
	DescribeTable("Add",
		func(a, b, expected int) {
			Expect(calculator.Add(a, b)).To(Equal(expected))
		},
		Entry("positive numbers", 1, 2, 3),
		Entry("negative numbers", -1, -2, -3),
		Entry("zero identity", 0, 5, 5),
	)

	DescribeTable("Mul",
		func(a, b, expected int) {
			Expect(calculator.Mul(a, b)).To(Equal(expected))
		},
		Entry("2 * 3 = 6", 2, 3, 6),
		Entry("identity element", 1, 7, 7),
		Entry("zero element", 0, 99, 0),
	)
})

var _ = DescribeTableSubtree("Div",
	func(a, b, expected int, expectErr bool) {
		It("returns the correct quotient", func() {
			result, err := calculator.Div(a, b)
			if expectErr {
				Expect(err).To(HaveOccurred())
			} else {
				Expect(err).NotTo(HaveOccurred())
				Expect(result).To(Equal(expected))
			}
		})
	},
	Entry("10 / 2 = 5", 10, 2, 5, false),
	Entry("9 / 3 = 3", 9, 3, 3, false),
	Entry("divide by zero", 1, 0, 0, true),
)
