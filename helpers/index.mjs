export const stack = [];
export const memory = {};
export const callable = {};

export const normalize = addr => {
  if (addr === "Acc") {
    return "A";
  }

  if (typeof addr === "string" && addr.startsWith("R")) {
    return `0${addr[1]}H`;
  }

  return addr;
};

export const push = addr => {
  addr = normalize(addr);
  stack.push(memory[addr]);
};

export const pop = addr => {
  addr = normalize(addr);
  memory[addr] = stack.pop();
};

export const SP = () => stack.length - 1;

export const mov = (addr, value, fromStack) => {
  addr = normalize(addr);

  if (typeof value === "string" && value.startsWith("@")) {
    value = normalize(value.substr(1));
    value = fromStack ? stack[memory[value]] : memory[value];
  }
  if (value === "B" || value === "A") {
    memory[addr] = memory[value];
  }
  else {
    memory[addr] = value;
  }
};

export const call = label => {
  stack.push("PC2 " + label);
  stack.push("PC1 " + label);

  callable[label]();
};

export const jmp = label => {
  callable[label]();
};

export const dec = addr => {
  addr = normalize(addr);
  memory[addr]--;
};

export const inc = addr => {
  addr = normalize(addr);
  memory[addr]++;
};

export const mul = (A, B) => {
  memory["A"] = memory["A"] * memory["B"]
};

export const jnz = label => {
  if (memory["A"]) {
    jmp(label);
    return false;
  }
  return true;
};

export const ret = () => {
  stack.pop();
  stack.pop();
};

export const printStack = (prefix = "") => {
  if(stack.length !== 0) {
    console.log(prefix, stack.reduce((acc, el) => acc = `${acc}     ${el}`));
  }
  else {
    console.log(prefix, "stack empty");
  }
}

export const printMemory = (prefix = "") => {
  console.log(prefix, memory);
}