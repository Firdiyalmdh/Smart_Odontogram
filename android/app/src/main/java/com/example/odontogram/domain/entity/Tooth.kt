package com.example.odontogram.domain.entity

import com.example.odontogram.R
import com.example.odontogram.domain.entity.ToothCondition.IMPAKSI
import com.example.odontogram.domain.entity.ToothCondition.KARIES
import com.example.odontogram.domain.entity.ToothCondition.NORMAL
import com.example.odontogram.domain.entity.ToothCondition.SISA_AKAR
import com.example.odontogram.domain.entity.ToothCondition.TUMPATAN
import com.example.odontogram.domain.entity.ToothType.CANINE
import com.example.odontogram.domain.entity.ToothType.INCISOR_1
import com.example.odontogram.domain.entity.ToothType.INCISOR_2

data class Tooth(
    val id: String,
    val type: ToothType,
    val condition: ToothCondition,
    val imagePath: String
) {
    val icon =
        when (type) {
            INCISOR_1, INCISOR_2, CANINE -> getClosedIcon()
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

enum class ToothType {
    INCISOR_1,
    INCISOR_2,
    CANINE,
    PREMOLAR_1,
    PREMOLAR_2,
    MOLAR_1,
    MOLAR_2,
    MOLAR_3
}

enum class ToothCondition {
    NORMAL,
    KARIES,
    TUMPATAN,
    SISA_AKAR,
    IMPAKSI
}
