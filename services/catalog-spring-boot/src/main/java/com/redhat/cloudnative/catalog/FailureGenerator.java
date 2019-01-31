/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.redhat.cloudnative.catalog;

import java.util.Map;
import java.util.Random;

/**
 * Created by ceposta 
 * <a href="http://christianposta.com/blog>http://christianposta.com/blog</a>.
 */
public class FailureGenerator {

    private static Random random = new Random(System.currentTimeMillis());
    private static long failOnceCounter = 1;


    public static void checkFailure(Map<String, String> headers) {


        Float failurePercentage = headers.containsKey("failure-percentage") ?  Float.valueOf(headers.get("failure-percentage")) : new Float(0);
        Long increasingFailOnce = headers.containsKey("fail-once") ?  Long.valueOf(headers.get("fail-once")) : null;
        Long resetCounterValue = headers.containsKey("reset-counter-to") ?  Long.valueOf(headers.get("reset-counter-to")) : new Long(0);

        // reset counters
        if (resetCounterValue >= 1) {
            failOnceCounter = resetCounterValue;
        }

        // fail once and go on
        if (increasingFailOnce != null && increasingFailOnce >= failOnceCounter ) {
            System.out.println("Counter is " + failOnceCounter + " setting to: " + Math.max((failOnceCounter++), increasingFailOnce));
            failOnceCounter = Math.max((failOnceCounter++), increasingFailOnce);
            fail();
        }

        // should we fail? probability of failure
        if (failurePercentage > 0) {
            float f = random.nextFloat() * 100;
            System.out.println("Failure? is " + f + " less than " + failurePercentage + "?");
            if (f < failurePercentage) {
                fail();
            }
        }

    }

    private static void fail(){
        throw new RuntimeException("Failure generated");
    }

}
