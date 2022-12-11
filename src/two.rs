use crate::utils::read_lines;

pub fn run() {
    if let Ok(lines) = read_lines("inputs/2.txt") {
        let mut suma = 0;
        let mut sumb = 0;

        for line in lines {
            if let Ok(ip) = line {
                suma += score_for(build_game_for_a(&ip));
                sumb += score_for(build_game_for_b(&ip));
            }
        }

        println!("{}", suma);
        println!("{}", sumb);
    }
}

#[derive(PartialEq)]
#[derive(Clone, Copy)]
enum Move {
    Rock,
    Paper,
    Scissors,
}

struct Game {
    enemy_move: Move,
    my_move: Move,
}

fn str_to_move(s: &str) -> Move {
    match s {
        "A" | "X" => Move::Rock,
        "B" | "Y" => Move::Paper,
        "C" | "Z" => Move::Scissors,
        _ => Move::Scissors
    }
}

fn str_to_move_two(outcome: &str, enemy_move: &Move) -> Move {
    match outcome {
        "X" => match enemy_move {
            Move::Rock => Move::Scissors,
            Move::Paper => Move::Rock,
            Move::Scissors => Move::Paper
        },
        "Y" => match enemy_move {
            Move::Rock => Move::Rock,
            Move::Paper => Move::Paper,
            Move::Scissors => Move::Scissors
        },
        "Z" => match enemy_move {
            Move::Rock => Move::Paper,
            Move::Paper => Move::Scissors,
            Move::Scissors => Move::Rock
        },
        _ => Move::Scissors
    }
}

fn build_game_for_a(line: &str) -> Game {
    let split = line.split(' ').collect::<Vec<&str>>();
    let enemy_move = split.first().expect("No first value");
    let my_move = split.last().expect("No last value");
    Game {
        enemy_move: str_to_move(enemy_move),
        my_move: str_to_move(my_move),
    }
}

fn build_game_for_b(line: &str) -> Game {
    let split = line.split(' ').collect::<Vec<&str>>();
    let enemy_move = str_to_move(split.first().expect("No first value"));
    let outcome = split.last().expect("No last value");
    Game {
        enemy_move,
        my_move: str_to_move_two(outcome, &enemy_move),
    }
}

fn score_for(game: Game) -> i32 {
    let ss = shape_score(&game);
    let os = outcome_score(&game);
    ss + os
}

fn shape_score(game: &Game) -> i32 {
    match game.my_move {
        Move::Rock => 1,
        Move::Paper => 2,
        Move::Scissors => 3
    }
}

fn outcome_score(game: &Game) -> i32 {
    if game.my_move == game.enemy_move {
        return 3;
    } else if game.my_move == Move::Rock {
        if game.enemy_move == Move::Paper {
            return 0;
        } else {
            return 6;
        }
    } else if game.my_move == Move::Paper {
        if game.enemy_move == Move::Scissors {
            return 0;
        } else {
            return 6;
        }
    } else {
        if game.enemy_move == Move::Rock {
            return 0;
        } else {
            return 6;
        }
    }
}
