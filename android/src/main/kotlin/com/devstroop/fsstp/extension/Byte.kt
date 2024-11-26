package com.devstroop.fsstp.extension


internal fun Byte.toIntAsUByte(): Int {
    return this.toInt() and 0x000000FF
}
