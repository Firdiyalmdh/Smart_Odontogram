package com.example.odontogram.domain.entity

import com.example.odontogram.R
import com.example.odontogram.domain.entity.ToothCondition.IMPAKSI
import com.example.odontogram.domain.entity.ToothCondition.KARIES
import com.example.odontogram.domain.entity.ToothCondition.NORMAL
import com.example.odontogram.domain.entity.ToothCondition.SISA_AKAR
import com.example.odontogram.domain.entity.ToothCondition.TUMPATAN
import com.example.odontogram.domain.entity.ToothType.SERI_1
import com.example.odontogram.domain.entity.ToothType.SERI_2
import com.example.odontogram.domain.entity.ToothType.TARING
import kotlinx.serialization.Serializable

@Serializable
data class Tooth(
    val id: String,
    val type: ToothType,
    val condition: ToothCondition,
    val imagePath: String
) {
    val icon =
        when (type) {
            SERI_1, SERI_2, TARING -> getClosedIcon()
            else -> getOpenIcon()
        }

    private fun getClosedIcon() = when (condition) {
        NORMAL -> R.drawable.normal1
        IMPAKSI -> R.drawable.impaksi1
        KARIES -> R.drawable.karies1
        SISA_AKAR -> R.drawable.sisa_akar1
        TUMPATAN -> R.drawable.tumpatan1
    }


    private fun getOpenIcon() = when (condition) {
        NORMAL -> R.drawable.normal
        IMPAKSI -> R.drawable.impaksi
        KARIES -> R.drawable.karies
        SISA_AKAR -> R.drawable.sisa_akar
        TUMPATAN -> R.drawable.tumpatan
    }
}

@Serializable
enum class ToothType(
    val q1: Int,
    val q2: Int,
    val q3: Int,
    val q4: Int
) {
    SERI_1(11, 21, 41, 31),
    SERI_2(12, 22, 42, 32),
    TARING(13, 23, 43, 33),
    PREMOLAR_1(14, 24, 44, 34),
    PREMOLAR_2(15, 25, 45, 35),
    MOLAR_1(16, 26, 46, 36),
    MOLAR_2(17, 27, 47, 37),
    MOLAR_3(18, 28, 48, 38)
}

fun ToothType.getId(quadrant: ToothQuadrant) = when (quadrant) {
    ToothQuadrant.QUADRANT_I -> q1
    ToothQuadrant.QUADRANT_II -> q2
    ToothQuadrant.QUADRANT_III -> q3
    ToothQuadrant.QUADRANT_IV -> q4
}

@Serializable
enum class ToothCondition {
    NORMAL,
    KARIES,
    TUMPATAN,
    SISA_AKAR,
    IMPAKSI
}

enum class ToothQuadrant {
    QUADRANT_I,
    QUADRANT_II,
    QUADRANT_III,
    QUADRANT_IV
}

fun ToothQuadrant.getIdList() = when (this) {
    ToothQuadrant.QUADRANT_I -> (11..18).toList()
    ToothQuadrant.QUADRANT_II -> (21..28).toList()
    ToothQuadrant.QUADRANT_III -> (41..48).toList()
    ToothQuadrant.QUADRANT_IV -> (31..38).toList()
}

fun ToothQuadrant.isReverse() = this == ToothQuadrant.QUADRANT_I || this == ToothQuadrant.QUADRANT_III

fun Int.toToothQuadrant(): ToothQuadrant = when (this) {
    1 -> ToothQuadrant.QUADRANT_I
    2 -> ToothQuadrant.QUADRANT_II
    3 -> ToothQuadrant.QUADRANT_III
    4 -> ToothQuadrant.QUADRANT_IV
    else -> ToothQuadrant.QUADRANT_I
}
