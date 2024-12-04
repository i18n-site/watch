import nowts from "@3-/nowts"

const STATUS = new Map()

export default STATUS

export const setErr = (name, item, err) => {
	const m = STATUS.get(name),
		pre = m.get(item)
	if (Array.isArray(pre)) {
		pre[1] = err
	} else {
		if (!Array.isArray(err)) {
			if (err instanceof Error) {
				err = err.message
			} else {
				err = err.toString()
			}
		}
		console.error("❌", name, item, err)
		m.set(item, [nowts(), err])
	}
}

export const setOk = (name, item) => {
	console.log("✅ " + name + " > " + item)
	STATUS.get(name).set(item, nowts())
}
