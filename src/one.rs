use crate::utils::read_lines;

pub fn run() {
    if let Ok(lines) = read_lines("inputs/1.txt") {
        let mut calories: Vec<i32> = Vec::new();
        let mut elves: Vec<Vec<i32>> = Vec::new();
        for line in lines {
            if let Ok(ip) = line {
                if ip.is_empty() {
                    elves.push(calories);
                    calories = Vec::new();
                } else {
                    calories.push(ip.parse().unwrap());
                }
            }
        }

        if calories.len() != 0 {
            elves.push(calories);
        }
        let mut sums: Vec<i32> = Vec::new();
        for elf in elves.iter() {
            sums.push(elf.iter().sum());
        }

        println!("{}", sums.iter().max().expect("No Maximum Found"));


        sums.sort();
        println!("{}", sums.iter().rev().take(3).sum::<i32>());
    }
}
