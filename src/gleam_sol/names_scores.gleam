import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn get_names_list(names: String) -> List(String) {
  names
  |> string.drop_start(1)
  |> string.drop_end(1)
  |> string.split("\",\"")
}

fn name_value(name: String) -> Result(Int, String) {
  let name = string.trim(name)
  case string.is_empty(name) {
    True -> Error("Пустое имя")
    False -> {
      use _ <- result.try(ensure_only_letters(name))
      Ok(calculate_score(name))
    }
  }
}

fn ensure_only_letters(name: String) -> Result(Nil, String) {
  let invalid =
    string.to_graphemes(name)
    |> list.find(fn(ch) {
      let assert [utf_codepoint, ..] = string.to_utf_codepoints(ch)
      let code = string.utf_codepoint_to_int(utf_codepoint)
      code < 65 || code > 90
    })

  case invalid {
    Ok(bad_char) ->
      Error("Недопустимый символ: '" <> bad_char <> "' в имени: " <> name)
    Error(Nil) -> Ok(Nil)
  }
}

fn calculate_score(name: String) -> Int {
  name
  |> string.uppercase
  |> string.to_graphemes
  |> list.fold(0, fn(acc, ch) {
    let assert [utf_codepoint, ..] = string.to_utf_codepoints(ch)
    let code = string.utf_codepoint_to_int(utf_codepoint) - 64
    acc + code
  })
}

pub fn recursive(names: List(String)) -> Result(Int, String) {
  use sorted <- result.try({
    let s = list.sort(names, string.compare)
    Ok(s)
  })

  rec_score(sorted, 1)
}

fn rec_score(names: List(String), pos: Int) -> Result(Int, String) {
  case names {
    [] -> Ok(0)
    [name, ..rest] -> {
      use value <- result.try(name_value(name))
      use rest_score <- result.try(rec_score(rest, pos + 1))
      Ok(value * pos + rest_score)
    }
  }
}

pub fn tail_recursive(names: List(String)) -> Result(Int, String) {
  let sorted = list.sort(names, string.compare)
  tail_score(sorted, 1, 0)
}

fn tail_score(names: List(String), pos: Int, acc: Int) -> Result(Int, String) {
  case names {
    [] -> Ok(acc)
    [name, ..rest] -> {
      use value <- result.try(name_value(name))
      tail_score(rest, pos + 1, acc + value * pos)
    }
  }
}

pub fn modular(names: List(String)) -> Result(Int, String) {
  let sorted = list.sort(names, string.compare)

  sorted
  |> list.index_map(fn(name, idx) {
    let pos = idx + 1
    result.map(name_value(name), fn(v) { v * pos })
  })
  |> result.all
  |> result.map(list.fold(_, 0, fn(a, b) { a + b }))
}

pub fn map_style(names: List(String)) -> Result(Int, String) {
  let sorted = list.sort(names, string.compare)

  let positions = list.range(1, list.length(sorted) + 1)

  list.zip(sorted, positions)
  |> list.map(fn(pair) {
    let #(name, pos) = pair
    result.map(name_value(name), fn(v) { v * pos })
  })
  |> result.all
  |> result.map(list.fold(_, 0, int.add))
}
