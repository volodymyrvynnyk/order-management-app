package com.pnu.ordermanagementapp.dto.order;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderFormSubmitDto {

    private long clientId;

    private long productId;

    private int amount;

}