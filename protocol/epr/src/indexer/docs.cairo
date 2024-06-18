use starknet::ContractAddress;

#[starknet::interface]
pub trait IDocs<TState> {
    fn set_epr_user(ref self: TState, epr_id: u128, user_id: u128);
    fn get_epr_user(self: @TState, user_id: u128) -> u128;
    fn set_epr_subject(ref self: TState, epr_id: u128, subject_key: u128);
}


#[starknet::contract]
pub mod Docs {
    use core::starknet::event::EventEmitter;
use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, SyscallResultTrait, syscalls
    };
    use components::ownable::ownable_component;

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;
    impl OwnableInternalImpl = ownable_component::OwnableInternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage,
        epr_users: LegacyMap::<u128, u128>,
        epr_subjects: LegacyMap::<u128, u128>,
        cids: LegacyMap::<felt252, u128>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        OwnableEvent: ownable_component::Event,
        SetUser: SetUser, 
        SetSubject: SetSubject,
    }

    #[derive(Drop, starknet::Event)]
    pub struct SetUser {
        #[key]
        pub epr_id: u128,
        pub timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    pub struct SetSubject {
        #[key]
        pub epr_id: u128,
        pub subject_id: u128,
        pub timestamp: u64,
    }

    pub mod Errors {
        pub const ACCESS_DENIED: felt252 = 'Docs: Access Denied';
        pub const ZERO_ERROR: felt252 = 'Docs: Zero Error';
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.ownable._init(get_caller_address());
    }

    #[abi(embed_v0)]
    impl DocsImpl of super::IDocs<ContractState> {

        fn set_epr_user(ref self: ContractState, epr_id: u128, user_id: u128) {
            self.ownable._assert_only_owner();

            assert(user_id != 0, Errors::ZERO_ERROR);

            self.epr_users.write(epr_id, user_id);
            let block_timestamp = get_block_timestamp(); 

            self.emit(SetUser {
                epr_id: epr_id,
                timestamp: block_timestamp,
            });
        }

        fn get_epr_user(self: @ContractState, user_id: u128) -> u128 {
            self.epr_users.read(user_id)
        }

        fn set_epr_subject(ref self: ContractState, epr_id: u128, subject_key: u128) {
            self.ownable._assert_only_owner();

            assert(subject_key != 0, Errors::ZERO_ERROR);

            self.epr_subjects.write(epr_id, subject_key);
            let block_timestamp = get_block_timestamp(); 

            self.emit(SetSubject {
                epr_id: epr_id,
                subject_id: subject_key,
                timestamp: block_timestamp,
            });
        }




    }

}