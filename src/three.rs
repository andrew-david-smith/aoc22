use crate::utils::read_lines;
use array_tool::vec::Intersect;

pub fn run() {
    if let Ok(lines) = read_lines("inputs/3.txt") {
        let mut sum = 0;
        let mut formatted_lines: Vec<Vec<char>> = Vec::new();

        for line in lines {
            if let Ok(ip) = line {
                let cloned_line = ip.clone();
                let sack = create_rucksack(ip);
                sum += priority(error_for(sack));
                formatted_lines.push(cloned_line.chars().collect());
            }
        }
        println!("{}", sum);

        sum = 0;
        let chunked_lines = formatted_lines.chunks(3);
        for group in chunked_lines {
            sum += priority(common_val_for(group));
        }

        println!("{}", sum);
    }
}

struct Rucksack {
    left: Vec<char>,
    right: Vec<char>,
}

fn create_rucksack(line: String) -> Rucksack {
    let chars: Vec<char> = line.chars().collect();
    let chunks: Vec<&[char]> = chars.chunks(chars.len()/2).collect();
    Rucksack {
        left: chunks.first().unwrap().to_vec(),
        right: chunks.last().unwrap().to_vec()
    }
}

fn error_for(sack: Rucksack) -> char {
    sack.left.intersect(sack.right)[0]
}

fn priority(c: char) -> i32 {
    if c.is_lowercase() {
        "abcdefghijklmnopqrstuvwxyz".chars().position( |l| l == c ).unwrap() as i32 + 1
    } else {
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars().position( |l| l == c ).unwrap() as i32 + 27
    }
}


fn common_val_for(group: &[Vec<char>]) -> char {
    let fst = group[0].clone();
    let snd = group[1].clone();
    let lst = group[2].clone();

    fst.intersect(snd).intersect(lst)[0]
}
