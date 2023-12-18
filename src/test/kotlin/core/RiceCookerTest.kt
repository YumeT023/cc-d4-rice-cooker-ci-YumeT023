package core

import core.RiceCooker
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

// TODO: Assert logs
class RiceCookerTest {
    private fun newRiceCooker() = RiceCooker()

    private fun newReadyRiceCooker(): RiceCooker {
        val rc = newRiceCooker()
        rc.isLidOpen = true

        // add food
        rc.addRiceCup(1f)
        rc.addWaterCup(1f)

        rc.isLidOpen = false
        rc.isPlugged = true

        return rc
    }

    @Test
    fun plugAndUnplug() {
        val rc = newRiceCooker()

        // default
        assertFalse { rc.isPlugged } // default
        rc.isPlugged = true;
        assertTrue { rc.isPlugged }
    }

    @Test
    fun canOpenAndCloseLid() {
        val rc = newRiceCooker()

        assertFalse { rc.isLidOpen } //  default
        rc.isPlugged = true;
        assertTrue { rc.isPlugged }
    }

    @Test
    fun addRiceCup() {
        val addCup = 2.5f
        val rc = newRiceCooker()

        assertEquals(rc.riceCup, 0f) // default

        // lid is not open so adding to it won't change the qty
        rc.addRiceCup(addCup)
        assertEquals(rc.riceCup, 0f) // default

        rc.isLidOpen = true;
        rc.addRiceCup(addCup)
        rc.addRiceCup(addCup)
        assertEquals(rc.riceCup, addCup * 2)
    }

    @Test
    fun addWaterCup() {
        val addCup = 2.5f
        val rc = newRiceCooker()

        assertEquals(rc.waterCup, 0f) // default

        // lid is not open so adding to it won't change the qty
        rc.addWaterCup(addCup)
        assertEquals(rc.waterCup, 0f) // default

        rc.isLidOpen = true;
        rc.addWaterCup(addCup)
        rc.addWaterCup(addCup)
        assertEquals(rc.waterCup, addCup * 2)
    }

    @Test
    fun cookRawFoodsAndGetServed() {
        val rc = newReadyRiceCooker()

        rc.cookRawFood()

        assertTrue { rc.isFoodReadyToServe }

        rc.isLidOpen = true;

        rc.getCooked()

        assertEquals(rc.riceCup, 0f)
        assertEquals(rc.waterCup, 0f)
    }
}
