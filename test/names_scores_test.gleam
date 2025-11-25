import gleam/io
import gleam/result
import gleam_sol/names_scores
import gleeunit/should
import simplifile

// Успешные сценарии

pub fn names_scores_basic_test() {
  let input = ["MARY", "PATRICIA", "LINDA"]

  names_scores.recursive(input)
  |> should.equal(Ok(385))

  names_scores.tail_recursive(input)
  |> should.equal(Ok(385))

  names_scores.modular(input)
  |> should.equal(Ok(385))

  names_scores.map_style(input)
  |> should.equal(Ok(385))
}

pub fn names_from_file_test() {
  let file_path = "names.txt"
  let file =
    simplifile.read(file_path)
    |> result.map_error(simplifile.describe_error)
  case file {
    Ok(names) -> {
      let names = names_scores.get_names_list(names)

      names_scores.recursive(names)
      |> should.equal(Ok(871_198_282))

      names_scores.tail_recursive(names)
      |> should.equal(Ok(871_198_282))

      names_scores.modular(names)
      |> should.equal(Ok(871_198_282))

      names_scores.map_style(names)
      |> should.equal(Ok(871_198_282))
    }
    Error(e) -> io.println("Error: " <> e)
  }
}

pub fn names_scores_single_name_test() {
  let input = ["COLIN"]

  names_scores.recursive(input)
  |> should.equal(Ok(53))
  names_scores.tail_recursive(input)
  |> should.equal(Ok(53))
  names_scores.modular(input)
  |> should.equal(Ok(53))
  names_scores.map_style(input)
  |> should.equal(Ok(53))
}

// Граничные случаи

pub fn names_scores_empty_list_test() {
  names_scores.recursive([])
  |> should.equal(Ok(0))

  names_scores.tail_recursive([])
  |> should.equal(Ok(0))

  names_scores.modular([])
  |> should.equal(Ok(0))

  names_scores.map_style([])
  |> should.equal(Ok(0))
}

pub fn names_scores_list_with_empty_name_test() {
  names_scores.recursive([""])
  |> should.equal(Error("Пустое имя"))

  names_scores.tail_recursive([""])
  |> should.equal(Error("Пустое имя"))

  names_scores.modular([""])
  |> should.equal(Error("Пустое имя"))

  names_scores.map_style([""])
  |> should.equal(Error("Пустое имя"))
}

// Большие тесты

pub fn names_scores_big_sorted_test() {
  let input = ["ZOE", "ADAM", "BRIAN", "CHARLES"]

  names_scores.recursive(input)
  |> should.equal(Ok(489))

  names_scores.tail_recursive(input)
  |> should.equal(Ok(489))

  names_scores.modular(input)
  |> should.equal(Ok(489))

  names_scores.map_style(input)
  |> should.equal(Ok(489))
}

// Ошибки

pub fn names_scores_multiple_errors_test() {
  let input = ["ANN4", "MIK3", "VALID"]

  names_scores.recursive(input)
  |> should.equal(Error("Недопустимый символ: '4' в имени: ANN4"))

  names_scores.tail_recursive(input)
  |> should.equal(Error("Недопустимый символ: '4' в имени: ANN4"))

  names_scores.modular(input)
  |> should.equal(Error("Недопустимый символ: '4' в имени: ANN4"))

  names_scores.map_style(input)
  |> should.equal(Error("Недопустимый символ: '4' в имени: ANN4"))
}

pub fn names_scores_mixed_case_test() {
  let input = ["alice", "BOB", "ChArLiE"]

  names_scores.recursive(input)
  |> should.equal(Error("Недопустимый символ: 'h' в имени: ChArLiE"))
  names_scores.tail_recursive(input)
  |> should.equal(Error("Недопустимый символ: 'h' в имени: ChArLiE"))
  names_scores.modular(input)
  |> should.equal(Error("Недопустимый символ: 'h' в имени: ChArLiE"))
  names_scores.map_style(input)
  |> should.equal(Error("Недопустимый символ: 'h' в имени: ChArLiE"))
}

pub fn names_scores_invalid_symbols_test() {
  names_scores.recursive(["ALICE", "BOB!", "@CARL"])
  |> should.equal(Error("Недопустимый символ: '@' в имени: @CARL"))

  names_scores.tail_recursive(["ALICE", "BOB!", "@CARL"])
  |> should.equal(Error("Недопустимый символ: '@' в имени: @CARL"))

  names_scores.modular(["ALICE", "BOB!", "@CARL"])
  |> should.equal(Error("Недопустимый символ: '@' в имени: @CARL"))

  names_scores.map_style(["ALICE", "BOB!", "@CARL"])
  |> should.equal(Error("Недопустимый символ: '@' в имени: @CARL"))
}

pub fn names_scores_invalid_char_test() {
  names_scores.recursive(["ANNA", "MIK3"])
  |> should.equal(Error("Недопустимый символ: '3' в имени: MIK3"))

  names_scores.tail_recursive(["ANNA", "MIK3"])
  |> should.equal(Error("Недопустимый символ: '3' в имени: MIK3"))

  names_scores.modular(["ANNA", "MIK3"])
  |> should.equal(Error("Недопустимый символ: '3' в имени: MIK3"))

  names_scores.map_style(["ANNA", "MIK3"])
  |> should.equal(Error("Недопустимый символ: '3' в имени: MIK3"))
}
