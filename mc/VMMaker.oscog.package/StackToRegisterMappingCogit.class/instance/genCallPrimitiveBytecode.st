bytecode generators
genCallPrimitiveBytecode
	"SistaV1: 248		11111000 	iiiiiiii		mjjjjjjj		Call Primitive #iiiiiiii + (jjjjjjj * 256) m=1 means inlined primitive, no hard return after execution.
	 See EncoderForSistaV1's class comment and StackInterpreter>>#inlinePrimitiveBytecode:"
	| prim |
	byte2 < 128 ifTrue:
		[^EncounteredUnknownBytecode].
	prim := byte2 - 128 << 8 + byte1.

	prim < 1000 ifTrue:
		[^self genUnaryInlinePrimitive: prim].
		
	prim < 2000 ifTrue:
		[self ssTop type = SSConstant ifTrue:
			[^self genBinaryVarOpConstInlinePrimitive: prim - 1000].
		 (self ssValue: 1) type = SSConstant ifTrue:
			[^self genBinaryConstOpVarInlinePrimitive: prim - 1000].
		 ^self genBinaryVarOpVarInlinePrimitive: prim - 1000].

	prim < 3000 ifTrue:
		[^self genTrinaryInlinePrimitive: prim - 2000].

	^EncounteredUnknownBytecode