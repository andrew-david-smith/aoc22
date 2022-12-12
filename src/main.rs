mod one;
mod two;
mod three;
mod four;
mod utils; 

fn main() {
    println!("---------------------------");
    println!("---------- Day 1 ----------");
    one::run();
    println!("---------------------------");
    println!("---------- Day 2 ----------");
    two::run();
    println!("---------------------------");
    println!("---------- Day 3 ----------");
    three::run();
    println!("---------------------------");
    println!("---------- Day 4 ----------");
    four::run();
}
