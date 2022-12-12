use crate::utils::read_lines;

pub fn run() {
    if let Ok(lines) = read_lines("inputs/4.txt") {
        let mut pairs: Vec<AssignmentPair> = Vec::new();
        for line in lines {
            if let Ok(ip) = line {
                pairs.push(create_assignment_pair(ip));
            }
        }

        let count = pairs.iter().filter( |p| one_fully_within_other(p) ).count();
        println!("{}", count);
        let count = pairs.iter().filter( |p| any_overlap(p) ).count();
        println!("{}", count);
    }
}

struct AssignmentPair {
    left: (i32,i32),
    right: (i32,i32),
}

fn create_assignment_pair(line: String) -> AssignmentPair {
    let elves = line.split(',').collect::<Vec<&str>>();
    let left_range_str = elves[0].split('-').collect::<Vec<&str>>();
    let right_range_str = elves[1].split('-').collect::<Vec<&str>>();
    let left = (left_range_str[0].parse::<i32>().unwrap(), left_range_str[1].parse::<i32>().unwrap());
    let right = (right_range_str[0].parse::<i32>().unwrap(), right_range_str[1].parse::<i32>().unwrap());
    AssignmentPair {
        left,
        right,
    }
}

fn one_fully_within_other(pair: &AssignmentPair) -> bool {
    pair.left.0 >= pair.right.0 && pair.left.1 <= pair.right.1 ||
      pair.right.0 >= pair.left.0 && pair.right.1 <= pair.left.1
}

fn any_overlap(pair: &AssignmentPair) -> bool {
    let smallest: (i32,i32);
    let largest: (i32,i32);

    if pair.left.0 < pair.right.0 {
        smallest = pair.left;
        largest = pair.right;
    } else {
        smallest = pair.right;
        largest = pair.left;
    }

    !(smallest.1 < largest.0)
}
