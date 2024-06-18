use starknet::ContractAddress;

#[starknet::interface]
pub trait IState<TState> {
}


#[starknet::contract]
pub mod State {
    use core::starknet::event::EventEmitter;
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, SyscallResultTrait, syscalls
    };

    #[storage]
    struct Storage {
        #[substorage(v0)]
        
    }


    #[constructor]
    fn constructor(ref self: ContractState) {
    }

    #[abi(embed_v0)]
    impl DocsImpl of super::IDocs<ContractState> {


    }

}