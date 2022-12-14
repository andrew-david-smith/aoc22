use crate::utils::read_lines;
use regex::Regex;

struct Cols {
    data: Vec<Vec<char>>,
}

impl Cols {
    fn output(& self) -> String {
        let mut output: String = "".to_owned();
        for col in &self.data {
            output += &col.last().unwrap().to_string();

        }
        output
    }

    fn perform_action(&mut self, action: &Action) {
        for _i in 0..action.times {
            if self.data[(action.from - 1) as usize].len() >= 1 {
                let popped = self.data[(action.from - 1) as usize].pop().unwrap();
                self.data[(action.to - 1) as usize].push(popped);
            }
        };
    }

    fn perform_b_action(&mut self, action: &Action) {
        let final_length = self.data[(action.from - 1) as usize].len() - (action.times as usize);

        let mut excess = self.data[(action.from - 1) as usize].split_off(final_length);
        self.data[(action.to - 1) as usize].append(&mut excess);
    }
}

pub fn run() {
    if let Ok(lines) = read_lines("inputs/5.txt") {
        let mut cols = Cols {
            data: vec![
                vec!['D', 'H', 'N', 'Q', 'T', 'W', 'V', 'B'],
                vec!['D', 'W', 'B'],
                vec!['T', 'S', 'Q', 'W', 'J', 'C'],
                vec!['F', 'J', 'R', 'N', 'Z', 'T', 'P'],
                vec!['G', 'P', 'V', 'J', 'M', 'S', 'T'],
                vec!['B', 'W', 'F', 'T', 'N'],
                vec!['B', 'L', 'D', 'Q', 'F', 'H', 'V', 'N'],
                vec!['H', 'P', 'F', 'R'],
                vec!['Z', 'S', 'M', 'B', 'L', 'N', 'P', 'H'],
            ]
        };

        let mut bcols = Cols {
            data: vec![
                vec!['D', 'H', 'N', 'Q', 'T', 'W', 'V', 'B'],
                vec!['D', 'W', 'B'],
                vec!['T', 'S', 'Q', 'W', 'J', 'C'],
                vec!['F', 'J', 'R', 'N', 'Z', 'T', 'P'],
                vec!['G', 'P', 'V', 'J', 'M', 'S', 'T'],
                vec!['B', 'W', 'F', 'T', 'N'],
                vec!['B', 'L', 'D', 'Q', 'F', 'H', 'V', 'N'],
                vec!['H', 'P', 'F', 'R'],
                vec!['Z', 'S', 'M', 'B', 'L', 'N', 'P', 'H'],
            ]
        };

        for line in lines {
            if let Ok(ip) = line {
                let action = create_action(ip);
                cols.perform_action(&action);
                bcols.perform_b_action(&action);
            }
        }

        println!("{}", cols.output());
        println!("{}", bcols.output());
    }
}

struct Action {
    from: i32,
    to: i32,
    times: i32
}

fn create_action(line: String) -> Action {
    let re = Regex::new(r"^move (\d+) from (\d) to (\d)$").unwrap();
    for cap in re.captures_iter(&line) {
        return Action {
            times: cap[1].parse::<i32>().unwrap(),
            from: cap[2].parse::<i32>().unwrap(),
            to: cap[3].parse::<i32>().unwrap(),
        }
    }

    panic!("baws");
}
