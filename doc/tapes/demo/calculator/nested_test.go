package calculator_test

import (
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"demo/calculator"
)

var _ = Describe("Calculator (nested)", func() {
	var a, b int

	BeforeEach(func() {
		a = 10
		b = 5
	})

	AfterEach(func() {
		// reset shared state after each spec
		a = 0
		b = 0
	})

	Context("addition", func() {
		It("returns the sum", func() {
			Expect(calculator.Add(a, b)).To(Equal(15))
		})

		When("both operands are negative", func() {
			BeforeEach(func() {
				a = -3
				b = -7
			})

			It("returns a negative sum", func() {
				Expect(calculator.Add(a, b)).To(Equal(-10))
			})
		})
	})

	Context("division", func() {
		It("divides evenly", func() {
			result, err := calculator.Div(a, b)
			Expect(err).NotTo(HaveOccurred())
			Expect(result).To(Equal(2))
		})

		When("the divisor is zero", func() {
			BeforeEach(func() {
				b = 0
			})

			Specify("it returns an error", func() {
				_, err := calculator.Div(a, b)
				Expect(err).To(HaveOccurred())
			})
		})
	})
})
