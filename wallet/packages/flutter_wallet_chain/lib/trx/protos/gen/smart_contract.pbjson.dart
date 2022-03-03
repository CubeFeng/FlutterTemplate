const SmartContract$json = const {
  '1': 'SmartContract',
  '2': const [
    const {'1': 'origin_address', '3': 1, '4': 1, '5': 12, '10': 'originAddress'},
    const {'1': 'contract_address', '3': 2, '4': 1, '5': 12, '10': 'contractAddress'},
    const {'1': 'abi', '3': 3, '4': 1, '5': 11, '6': '.protocol.SmartContract.ABI', '10': 'abi'},
    const {'1': 'bytecode', '3': 4, '4': 1, '5': 12, '10': 'bytecode'},
    const {'1': 'call_value', '3': 5, '4': 1, '5': 3, '10': 'callValue'},
    const {'1': 'consume_user_resource_percent', '3': 6, '4': 1, '5': 3, '10': 'consumeUserResourcePercent'},
    const {'1': 'name', '3': 7, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'origin_energy_limit', '3': 8, '4': 1, '5': 3, '10': 'originEnergyLimit'},
    const {'1': 'code_hash', '3': 9, '4': 1, '5': 12, '10': 'codeHash'},
    const {'1': 'trx_hash', '3': 10, '4': 1, '5': 12, '10': 'trxHash'},
  ],
  '3': const [SmartContract_ABI$json],
};

const SmartContract_ABI$json = const {
  '1': 'ABI',
  '2': const [
    const {'1': 'entrys', '3': 1, '4': 3, '5': 11, '6': '.protocol.SmartContract.ABI.Entry', '10': 'entrys'},
  ],
  '3': const [SmartContract_ABI_Entry$json],
};

const SmartContract_ABI_Entry$json = const {
  '1': 'Entry',
  '2': const [
    const {'1': 'anonymous', '3': 1, '4': 1, '5': 8, '10': 'anonymous'},
    const {'1': 'constant', '3': 2, '4': 1, '5': 8, '10': 'constant'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'inputs', '3': 4, '4': 3, '5': 11, '6': '.protocol.SmartContract.ABI.Entry.Param', '10': 'inputs'},
    const {'1': 'outputs', '3': 5, '4': 3, '5': 11, '6': '.protocol.SmartContract.ABI.Entry.Param', '10': 'outputs'},
    const {'1': 'type', '3': 6, '4': 1, '5': 14, '6': '.protocol.SmartContract.ABI.Entry.EntryType', '10': 'type'},
    const {'1': 'payable', '3': 7, '4': 1, '5': 8, '10': 'payable'},
    const {'1': 'stateMutability', '3': 8, '4': 1, '5': 14, '6': '.protocol.SmartContract.ABI.Entry.StateMutabilityType', '10': 'stateMutability'},
  ],
  '3': const [SmartContract_ABI_Entry_Param$json],
  '4': const [SmartContract_ABI_Entry_EntryType$json, SmartContract_ABI_Entry_StateMutabilityType$json],
};

const SmartContract_ABI_Entry_Param$json = const {
  '1': 'Param',
  '2': const [
    const {'1': 'indexed', '3': 1, '4': 1, '5': 8, '10': 'indexed'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
  ],
};

const SmartContract_ABI_Entry_EntryType$json = const {
  '1': 'EntryType',
  '2': const [
    const {'1': 'UnknownEntryType', '2': 0},
    const {'1': 'Constructor', '2': 1},
    const {'1': 'Function', '2': 2},
    const {'1': 'Event', '2': 3},
    const {'1': 'Fallback', '2': 4},
    const {'1': 'Receive', '2': 5},
  ],
};

const SmartContract_ABI_Entry_StateMutabilityType$json = const {
  '1': 'StateMutabilityType',
  '2': const [
    const {'1': 'UnknownMutabilityType', '2': 0},
    const {'1': 'Pure', '2': 1},
    const {'1': 'View', '2': 2},
    const {'1': 'Nonpayable', '2': 3},
    const {'1': 'Payable', '2': 4},
  ],
};

const CreateSmartContract$json = const {
  '1': 'CreateSmartContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'new_contract', '3': 2, '4': 1, '5': 11, '6': '.protocol.SmartContract', '10': 'newContract'},
    const {'1': 'call_token_value', '3': 3, '4': 1, '5': 3, '10': 'callTokenValue'},
    const {'1': 'token_id', '3': 4, '4': 1, '5': 3, '10': 'tokenId'},
  ],
};

const TriggerSmartContract$json = const {
  '1': 'TriggerSmartContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'contract_address', '3': 2, '4': 1, '5': 12, '10': 'contractAddress'},
    const {'1': 'call_value', '3': 3, '4': 1, '5': 3, '10': 'callValue'},
    const {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'call_token_value', '3': 5, '4': 1, '5': 3, '10': 'callTokenValue'},
    const {'1': 'token_id', '3': 6, '4': 1, '5': 3, '10': 'tokenId'},
  ],
};

const ClearABIContract$json = const {
  '1': 'ClearABIContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'contract_address', '3': 2, '4': 1, '5': 12, '10': 'contractAddress'},
  ],
};

const UpdateSettingContract$json = const {
  '1': 'UpdateSettingContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'contract_address', '3': 2, '4': 1, '5': 12, '10': 'contractAddress'},
    const {'1': 'consume_user_resource_percent', '3': 3, '4': 1, '5': 3, '10': 'consumeUserResourcePercent'},
  ],
};

const UpdateEnergyLimitContract$json = const {
  '1': 'UpdateEnergyLimitContract',
  '2': const [
    const {'1': 'owner_address', '3': 1, '4': 1, '5': 12, '10': 'ownerAddress'},
    const {'1': 'contract_address', '3': 2, '4': 1, '5': 12, '10': 'contractAddress'},
    const {'1': 'origin_energy_limit', '3': 3, '4': 1, '5': 3, '10': 'originEnergyLimit'},
  ],
};

const SmartContractDataWrapper$json = const {
  '1': 'SmartContractDataWrapper',
  '2': const [
    const {'1': 'smart_contract', '3': 1, '4': 1, '5': 11, '6': '.protocol.SmartContract', '10': 'smartContract'},
    const {'1': 'runtimecode', '3': 2, '4': 1, '5': 12, '10': 'runtimecode'},
  ],
};

