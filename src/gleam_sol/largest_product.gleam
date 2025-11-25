import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn check_input(number: String, l: Int) -> Result(Int, String) {
  case string.length(number) < l {
    True -> Error("'l' must be less than or equal to the length of the number")
    False ->
      case l > 0 {
        True -> Ok(1)
        False -> Error("'l' must be positive")
      }
  }
}

pub fn recursive(number: String, l: Int) -> Result(Int, String) {
  case check_input(number, l) {
    Ok(_) -> rec_main(number, l, 0)
    Error(e) -> Error(e)
  }
}

fn rec_main(number: String, l: Int, index: Int) -> Result(Int, String) {
  case index > string.length(number) - l {
    True -> Ok(0)
    False -> {
      let substring = string.slice(number, index, l)
      let digits = string.to_graphemes(substring)

      case calc_prod(digits, 1) {
        Ok(current_prod) -> {
          let rest_result = rec_main(number, l, index + 1)
          case rest_result {
            Ok(max_from_rest) -> Ok(int.max(current_prod, max_from_rest))
            Error(e) -> Error(e)
          }
        }
        Error(e) -> Error(e)
      }
    }
  }
}

pub fn tail_recursive(number: String, l: Int) -> Result(Int, String) {
  case check_input(number, l) {
    Ok(_) -> tail_rec_main(number, l, 0, 0)
    Error(e) -> Error(e)
  }
}

fn tail_rec_main(
  number: String,
  l: Int,
  index: Int,
  max_prod: Int,
) -> Result(Int, String) {
  case index > string.length(number) - l {
    True -> Ok(max_prod)
    False -> {
      let sub_number = string.slice(number, index, l)
      case calc_prod(string.to_graphemes(sub_number), 1) {
        Ok(n) -> tail_rec_main(number, l, index + 1, int.max(max_prod, n))
        Error(e) -> Error(e)
      }
    }
  }
}

fn calc_prod(numbers: List(String), acc: Int) -> Result(Int, String) {
  case numbers {
    [] -> Ok(acc)
    [first, ..rest] -> {
      case int.parse(first) {
        Ok(n) -> {
          calc_prod(rest, acc * n)
        }
        Error(_) -> Error("Can't parse: \"" <> first <> "\"")
      }
    }
  }
}

pub fn modular(digits: String, length: Int) -> Result(Int, String) {
  check_input(digits, length)
  |> result.try(fn(_) {
    digits
    |> generate_slices(length)
    |> compute_products
    |> find_max_product
  })
}

fn generate_slices(digits: String, length: Int) -> List(String) {
  let len = string.length(digits)
  list.range(0, len - length)
  |> list.map(fn(start) { string.slice(digits, start, length) })
}

fn compute_products(slices: List(String)) -> List(Result(Int, String)) {
  list.map(slices, product_of_slice)
}

fn product_of_slice(slice: String) -> Result(Int, String) {
  slice
  |> string.to_graphemes
  |> list.try_fold(1, fn(acc, ch) {
    case int.parse(ch) {
      Ok(n) -> Ok(acc * n)
      Error(_) -> Error("Can't parse: \"" <> ch <> "\"")
    }
  })
}

fn find_max_product(products: List(Result(Int, String))) -> Result(Int, String) {
  products
  |> result.all
  |> result.map(fn(valid_products) { list.fold(valid_products, 0, int.max) })
}

pub fn map_style(digits: String, length: Int) -> Result(Int, String) {
  check_input(digits, length)
  |> result.try(fn(_) {
    let total_len = string.length(digits)

    list.range(0, total_len - length)
    |> list.map(fn(start) {
      let slice = string.slice(digits, start, length)
      result.try(product_of_slice(slice), fn(prod) { Ok(prod) })
    })
    |> result.all
    |> result.map(fn(prods) { prods |> list.fold(0, int.max) })
  })
}
