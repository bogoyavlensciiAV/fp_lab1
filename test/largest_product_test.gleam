import gleam_sol/largest_product
import gleeunit/should

// Успешные сценарии

pub fn largest_product_13_digits_test() {
  let input = "73167176531330624919225119674426574742355349194934"
  largest_product.recursive(input, 13)
  |> should.equal(Ok(568_995_840))
  largest_product.tail_recursive(input, 13)
  |> should.equal(Ok(568_995_840))
  largest_product.modular(input, 13)
  |> should.equal(Ok(568_995_840))
  largest_product.map_style(input, 13)
  |> should.equal(Ok(568_995_840))
}

pub fn largest_product_single_digit_test() {
  largest_product.recursive("123456789", 1)
  |> should.equal(Ok(9))
  largest_product.tail_recursive("123456789", 1)
  |> should.equal(Ok(9))
  largest_product.modular("123456789", 1)
  |> should.equal(Ok(9))
  largest_product.map_style("123456789", 1)
  |> should.equal(Ok(9))
}

pub fn largest_product_full_input_test() {
  let full_number =
    "7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450"
  largest_product.recursive(full_number, 13)
  |> should.equal(Ok(23_514_624_000))
  largest_product.tail_recursive(full_number, 13)
  |> should.equal(Ok(23_514_624_000))
  largest_product.modular(full_number, 13)
  |> should.equal(Ok(23_514_624_000))
  largest_product.map_style(full_number, 13)
  |> should.equal(Ok(23_514_624_000))
}

pub fn largest_product_with_zero_test() {
  largest_product.recursive("1234056789", 6)
  |> should.equal(Ok(0))
  largest_product.tail_recursive("1234056789", 6)
  |> should.equal(Ok(0))
  largest_product.modular("1234056789", 6)
  |> should.equal(Ok(0))
  largest_product.map_style("1234056789", 6)
  |> should.equal(Ok(0))
}

pub fn largest_product_all_same_digits_test() {
  largest_product.recursive("9999999999", 4)
  |> should.equal(Ok(6561))
  largest_product.tail_recursive("9999999999", 4)
  |> should.equal(Ok(6561))
  largest_product.modular("9999999999", 4)
  |> should.equal(Ok(6561))
  largest_product.map_style("9999999999", 4)
  |> should.equal(Ok(6561))
}

// Граничные случаи

pub fn largest_product_empty_string_test() {
  largest_product.recursive("", 5)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.tail_recursive("", 5)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.modular("", 5)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.map_style("", 5)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
}

pub fn largest_product_shorter_than_l_test() {
  largest_product.recursive("1234", 10)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.tail_recursive("1234", 10)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.modular("1234", 10)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.map_style("1234", 10)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
}

pub fn largest_product_l_is_zero_test() {
  largest_product.recursive("123456", 0)
  |> should.equal(Error("'l' must be positive"))
  largest_product.tail_recursive("123456", 0)
  |> should.equal(Error("'l' must be positive"))
  largest_product.modular("123456", 0)
  |> should.equal(Error("'l' must be positive"))
  largest_product.map_style("123456", 0)
  |> should.equal(Error("'l' must be positive"))
}

pub fn largest_product_l_is_one_test() {
  largest_product.recursive("987654321", 1)
  |> should.equal(Ok(9))
  largest_product.tail_recursive("987654321", 1)
  |> should.equal(Ok(9))
  largest_product.modular("987654321", 1)
  |> should.equal(Ok(9))
  largest_product.map_style("987654321", 1)
  |> should.equal(Ok(9))
}

pub fn largest_product_l_equals_length_test() {
  largest_product.recursive("258", 3)
  |> should.equal(Ok(80))
  largest_product.tail_recursive("258", 3)
  |> should.equal(Ok(80))
  largest_product.modular("258", 3)
  |> should.equal(Ok(80))
  largest_product.map_style("258", 3)
  |> should.equal(Ok(80))
}

// Негативные тесты (ошибки ввода)

pub fn largest_product_contains_non_digit_test() {
  largest_product.recursive("123a56789", 4)
  |> should.equal(Error("Can't parse: \"a\""))
  largest_product.tail_recursive("123a56789", 4)
  |> should.equal(Error("Can't parse: \"a\""))
  largest_product.modular("123a56789", 4)
  |> should.equal(Error("Can't parse: \"a\""))
  largest_product.map_style("123a56789", 4)
  |> should.equal(Error("Can't parse: \"a\""))
}

pub fn largest_product_negative_l_test() {
  largest_product.recursive("123456", -5)
  |> should.equal(Error("'l' must be positive"))
  largest_product.tail_recursive("123456", -5)
  |> should.equal(Error("'l' must be positive"))
  largest_product.modular("123456", -5)
  |> should.equal(Error("'l' must be positive"))
  largest_product.map_style("123456", -5)
  |> should.equal(Error("'l' must be positive"))
}

pub fn largest_product_huge_l_test() {
  largest_product.recursive("123", 1000)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.tail_recursive("123", 1000)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.modular("123", 1000)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
  largest_product.map_style("123", 1000)
  |> should.equal(Error(
    "'l' must be less than or equal to the length of the number",
  ))
}
