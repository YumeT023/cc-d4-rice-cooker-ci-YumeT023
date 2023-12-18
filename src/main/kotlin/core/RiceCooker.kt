package core

import tui.Printer


const val DEFAULT_RICE_COOKER_CAPACITY = 2f
const val WATER_TO_RICE_RATIO = 0.5f

class RiceCooker(val capacity: Float? = DEFAULT_RICE_COOKER_CAPACITY) {
    var isPlugged = false
        set(value) {
            if (value == field) {
                Printer.info("The plug is already ${getTextualStatus().plug}")
            }
            field = value
        }

    var isLidOpen = false
        set(value) {
            if (isPlugged) {
                Printer.dangerous("You shouldn't be touching the lid")
            }
            if (value == field) {
                Printer.info("The lid is already ${getTextualStatus().lid}")
            }
            field = value
        }

    var riceCup: Float = 0.0f
        private set

    var waterCup: Float = 0.0f
        private set

    var isFoodReadyToServe = false
        private set

    fun addRiceCup(cup: Float = 0.0f) {
        if (!isLidOpen) {
            Printer.info("Consider opening the inner pot lid");
            return;
        }
        riceCup += cup
    }

    fun addWaterCup(cup: Float = 0.0f) {
        if (!isLidOpen) {
            Printer.info("Consider opening the inner pot lid");
            return;
        }
        waterCup += cup
    }

    fun cookRawFood() {
        if (isFoodReadyToServe) {
            Printer.info("Food is ready to be served, empty the inner pot to cook other")
            return;
        }
        println("Cooking..., [WARN] for your security, don't try to cancel the operation")
        Thread.sleep((getEstimatedCookSeconds() * 1_000).toLong())
        println("Food is ready to be served")
        isFoodReadyToServe = true;
    }

    fun getCooked() {
        if (!isLidOpen) {
            Printer.info("Consider removing the inner port's cover")
            return;
        }
        riceCup = 0f
        waterCup = 0f
        isFoodReadyToServe = false
    }

    fun logRecommendation() {
        if (isFoodReadyToServe) {
            Printer.recommendation("You can get the cooked food now")
            return
        }
        if (!isLidOpen) return

        if (riceCup == 0.0f) {
            Printer.recommendation("Begin by placing raw food")
        } else {
            val recommended = getRecommendedWaterToRice()
            if (recommended != waterCup) {
                Printer.recommendation("For this cup of rice, $recommended cup of water is the ideal for a well cooked rice:D")
            } else {
                Printer.recommendation("You're already good to go")
            }
        }
    }

    private fun getEstimatedCookSeconds() = riceCup * 5 /* 5s per cup */

    private fun getRecommendedWaterToRice() = riceCup * WATER_TO_RICE_RATIO

    private fun getTextualStatus() = TextualStatus(
        if (isLidOpen) "opened" else "closed",
        if (isPlugged) "plugged" else "unplugged"
    )

    data class TextualStatus(val lid: String, val plug: String)
}
