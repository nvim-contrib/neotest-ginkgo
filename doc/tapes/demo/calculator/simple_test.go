package calculator_test

import (
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"demo/calculator"
)

var _ = Describe("Calculator", func() {
	It("adds two numbers", func() {
		Expect(calculator.Add(2, 3)).To(Equal(5))
	})

	It("subtracts two numbers", func() {
		Expect(calculator.Sub(10, 4)).To(Equal(6))
	})

	It("multiplies two numbers", func() {
		Expect(calculator.Mul(3, 7)).To(Equal(21))
	})

	It("divides two numbers", func() {
		result, err := calculator.Div(10, 2)
		Expect(err).NotTo(HaveOccurred())
		Expect(result).To(Equal(5))
	})

	It("returns an error when dividing by zero", func() {
		_, err := calculator.Div(1, 0)
		Expect(err).To(MatchError("division by zero"))
	})
})
