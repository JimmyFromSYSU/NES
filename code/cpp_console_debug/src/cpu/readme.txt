################################# uncheck op
CMP/CPY/CPX
BIT		
ADC/SBC

################################# stack op
void cpu::push(unsigned char t){
    mem.set(--SP,t);
}
unsigned char cpu::pop(){
    return mem.get(SP++);
}

################################# Interupt