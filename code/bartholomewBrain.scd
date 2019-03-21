(

s.waitForBoot({
	SynthDef(\voiceSynth, {arg baseFreq = 20, freqLo = 30, freqHi = 200, delayLo = 0.5, delayHi = 4, delayModRate = 0.14, sigMix;

		var out, voice, response;

		// Sleep Mode
		var baseScaler = 0.3;
		var lPCutoff = 300;
		var baseSin = SinOsc.ar(LFNoise1.kr(0.16).range(baseFreq, baseFreq * 2)) * baseScaler;

		// Signal for response
		var voiceScaler = 0.7;
		var freqChangeRate = 0.24;
		var freqChangeRange = [0.25, 4];
		var voiceNoise = LFNoise2.ar(
			LFNoise2.kr(0.17).range(50, lPCutoff)
		);
		var voiceSin = SinOsc.ar(
			LFNoise0.kr(
				LFNoise2.ar(freqChangeRate)
				.range(
					freqChangeRange[0],
					freqChangeRange[1]
				)
			).range(freqLo, freqHi)
		);
		voiceNoise = voiceNoise * LFNoise2.kr(0.12, mul: 0.14);
		voiceSin = voiceSin * voiceScaler;

		response = SelectX.ar(sigMix.lag(5), [voiceNoise, voiceSin]);

		voice = SoundIn.ar(1);
		voice = DelayC.ar(voice, maxdelaytime: 5, delaytime: LFNoise2.kr(delayModRate).range(delayLo, delayHi));

		response = response * Amplitude.kr(voice);
		out = baseSin + response;

		Out.ar(0, [out, out]);
	}).add;
	s.sync;
	~voiceControl = Synth(\voiceSynth);
});
)

(
OSCdef(\takeMode, {arg ...args;
	var mode = args[0][1];
	case
	{mode == 1} {
		"purple".postln;
		~voiceControl.set(\sigMix, 0, \delayLo, 0.1, \delayHi, 0.4);
	}
	{mode == 2} {
		"blue".postln;
		~voiceControl.set(\sigMix, 1, \delayLo, 2, \delayHi, 4);

	}
	{mode == 3} {
		"both".postln;
		~voiceControl.set(\sigMix, 2, \delayLo, 1, \delayHi, 3);

	}
}, '/mode');
)

// Test Freqs
(s.waitForBoot({
SynthDef(\sin, {arg freq, amp = 1;
	Out.ar(0, {SinOsc.ar(freq)}!2 * amp);
}).add;
s.sync;
~sinOsc = Synth.new(\sin, [\freq, 55]);

~slide = EZSlider(label: "freq", controlSpec: ControlSpec(55, 5000, 'exp'), action: {arg obj;
	~sinOsc.set(\freq, obj.value);
});
});
)

