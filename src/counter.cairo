#[starknet::interface]
trait ICounter<T> {
    fn get_counter(self:@T ) -> u32;
    fn increase_counter(ref self: T);
}

#[starknet::contract]
pub mod counter_contract{
    use starknet::event::EventEmitter;
use starknet::storage::StoragePointerReadAccess;
    use super::ICounter;
    use starknet::storage::StoragePointerWriteAccess;
    #[storage]
    struct Storage {
        counter : u32
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event{
        CounterIncreased : CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased{
        #[key]
        value: u32,
    }

    #[constructor]
    fn constructor(ref self:ContractState, initial_value: u32){
        self.counter.write(initial_value);
    }

    #[abi(embed_v0)]
    impl counterImpl of ICounter<ContractState>{
        fn get_counter (self:@ContractState) -> u32{
            self.counter.read()
        }

        fn increase_counter(ref self : ContractState){
            self.counter.write(self.counter.read() + 1);
            self.emit(CounterIncreased{value: self.counter.read()});
        }
    }
}