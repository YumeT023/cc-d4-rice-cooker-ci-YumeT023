package tui

import tui.Printer.PrintFlag.*

object Printer {
    enum class PrintFlag {
        ERROR,
        WARNING,
        DANGEROUS,
        RECOMMENDATION,
        INFO
    }

    private fun printlnWithFlag(flag: PrintFlag, message: String) {
        print("[$flag] $message")
    }

    fun logo() {
        println("""
Y88b      / 888 888          e      888b    | Y88b    /
 Y88b    /  888 888         d8b     |Y88b   |  Y88b  / 
  Y88b  /   888 888        /Y88b    | Y88b  |   Y88b/  
   Y888/    888 888       /  Y88b   |  Y88b |    Y8Y   
    Y8/     888 888      /____Y88b  |   Y88b|     Y    
     Y      888 888____ /      Y88b |    Y888    /     
        """.trimIndent())
    }

    fun info(message: String) = printlnWithFlag(INFO, message)

    fun error(message: String) = printlnWithFlag(ERROR, message)

    fun warning(message: String) = printlnWithFlag(WARNING, message)

    fun dangerous(message: String) = printlnWithFlag(DANGEROUS, message)

    fun recommendation(message: String) = printlnWithFlag(RECOMMENDATION, message)
}
