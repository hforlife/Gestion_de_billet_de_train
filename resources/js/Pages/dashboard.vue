<script setup>
import AppLayout from "@/layouts/AppLayout.vue";
import { defineProps } from 'vue';


const props = defineProps({
    employees: Array,
    tickets: Array,
    trains: Array,
    gares: Array,
});
</script>

<template>
    <AppLayout>
                <!-- Page Title Header Starts-->
                <div class="row page-title-header">
                    <div class="col-12">
                        <div class="page-header">
                            <h4 class="page-title">Tableau de bord</h4>
                        </div>
                    </div>
                </div>
                <!-- Page Title Header Ends-->
                <div></div>
                <!-- Count -->
                <div class="row">
                    <div class="col-md-12 grid-margin">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-lg-3 col-md-6">
                                        <div class="d-flex">
                                            <div class="wrapper">
                                                <h3
                                                    class="mb-0 font-weight-semibold"
                                                >
                                                    {{ employees }}
                                                </h3>
                                                <h5
                                                    class="mb-0 font-weight-medium text-primary"
                                                >
                                                    Total Employee
                                                </h5>
                                                <!-- <p class="mb-0 text-muted">
                                                    +14.00(+0.50%)
                                                </p> -->
                                            </div>
                                            <div
                                                class="wrapper my-auto ml-auto ml-lg-4"
                                            >
                                                <div
                                                    class="chartjs-size-monitor"
                                                    style="
                                                        position: absolute;
                                                        inset: 0px;
                                                        overflow: hidden;
                                                        pointer-events: none;
                                                        visibility: hidden;
                                                        z-index: -1;
                                                    "
                                                >
                                                    <div
                                                        class="chartjs-size-monitor-expand"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 1000000px;
                                                                height: 1000000px;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                    <div
                                                        class="chartjs-size-monitor-shrink"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 200%;
                                                                height: 200%;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                </div>
                                                <canvas
                                                    height="50"
                                                    width="100"
                                                    id="stats-line-graph-1"
                                                    class="chartjs-render-monitor"
                                                    style="display: block"
                                                ></canvas>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mt-md-0 mt-4">
                                        <div class="d-flex">
                                            <div class="wrapper">
                                                <h3
                                                    class="mb-0 font-weight-semibold"
                                                >
                                                    {{ tickets }}
                                                </h3>
                                                <h5
                                                    class="mb-0 font-weight-medium text-primary"
                                                >
                                                    Tickets
                                                </h5>
                                                <!-- <p class="mb-0 text-muted">
                                                    +138.97(+0.54%)
                                                </p> -->
                                            </div>
                                            <div
                                                class="wrapper my-auto ml-auto ml-lg-4"
                                            >
                                                <div
                                                    class="chartjs-size-monitor"
                                                    style="
                                                        position: absolute;
                                                        inset: 0px;
                                                        overflow: hidden;
                                                        pointer-events: none;
                                                        visibility: hidden;
                                                        z-index: -1;
                                                    "
                                                >
                                                    <div
                                                        class="chartjs-size-monitor-expand"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 1000000px;
                                                                height: 1000000px;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                    <div
                                                        class="chartjs-size-monitor-shrink"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 200%;
                                                                height: 200%;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                </div>
                                                <canvas
                                                    height="50"
                                                    width="100"
                                                    id="stats-line-graph-2"
                                                    class="chartjs-render-monitor"
                                                    style="display: block"
                                                ></canvas>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mt-md-0 mt-4">
                                        <div class="d-flex">
                                            <div class="wrapper">
                                                <h3
                                                    class="mb-0 font-weight-semibold"
                                                >
                                                   {{trains}}
                                                </h3>
                                                <h5
                                                    class="mb-0 font-weight-medium text-primary"
                                                >
                                                    Trains
                                                </h5>
                                                <!-- <p class="mb-0 text-muted">
                                                    +57.62(+0.76%)
                                                </p> -->
                                            </div>
                                            <div
                                                class="wrapper my-auto ml-auto ml-lg-4"
                                            >
                                                <div
                                                    class="chartjs-size-monitor"
                                                    style="
                                                        position: absolute;
                                                        inset: 0px;
                                                        overflow: hidden;
                                                        pointer-events: none;
                                                        visibility: hidden;
                                                        z-index: -1;
                                                    "
                                                >
                                                    <div
                                                        class="chartjs-size-monitor-expand"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 1000000px;
                                                                height: 1000000px;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                    <div
                                                        class="chartjs-size-monitor-shrink"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 200%;
                                                                height: 200%;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                </div>
                                                <canvas
                                                    height="50"
                                                    width="100"
                                                    id="stats-line-graph-3"
                                                    class="chartjs-render-monitor"
                                                    style="display: block"
                                                ></canvas>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-3 col-md-6 mt-md-0 mt-4">
                                        <div class="d-flex">
                                            <div class="wrapper">
                                                <h3
                                                    class="mb-0 font-weight-semibold"
                                                >
                                                   {{gares}}
                                                </h3>
                                                <h5
                                                    class="mb-0 font-weight-medium text-primary"
                                                >
                                                    Gares
                                                </h5>
                                                <!-- <p class="mb-0 text-muted">
                                                    +138.97(+0.54%)
                                                </p> -->
                                            </div>
                                            <div
                                                class="wrapper my-auto ml-auto ml-lg-4"
                                            >
                                                <div
                                                    class="chartjs-size-monitor"
                                                    style="
                                                        position: absolute;
                                                        inset: 0px;
                                                        overflow: hidden;
                                                        pointer-events: none;
                                                        visibility: hidden;
                                                        z-index: -1;
                                                    "
                                                >
                                                    <div
                                                        class="chartjs-size-monitor-expand"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 1000000px;
                                                                height: 1000000px;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                    <div
                                                        class="chartjs-size-monitor-shrink"
                                                        style="
                                                            position: absolute;
                                                            left: 0;
                                                            top: 0;
                                                            right: 0;
                                                            bottom: 0;
                                                            overflow: hidden;
                                                            pointer-events: none;
                                                            visibility: hidden;
                                                            z-index: -1;
                                                        "
                                                    >
                                                        <div
                                                            style="
                                                                position: absolute;
                                                                width: 200%;
                                                                height: 200%;
                                                                left: 0;
                                                                top: 0;
                                                            "
                                                        ></div>
                                                    </div>
                                                </div>
                                                <canvas
                                                    height="50"
                                                    width="100"
                                                    id="stats-line-graph-4"
                                                    class="chartjs-render-monitor"
                                                    style="display: block"
                                                ></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Tables -->
                <div class="row">
                    <!-- Table 1 -->
                    <div class="col-lg-6 grid-margin stretch-card">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title">Basic Table</h4>
                                <p class="card-description">
                                    Add class <code>.table</code>
                                </p>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Profile</th>
                                            <th>VatNo.</th>
                                            <th>Created</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Jacob</td>
                                            <td>53275531</td>
                                            <td>12 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-danger"
                                                    >Pending</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Messsy</td>
                                            <td>53275532</td>
                                            <td>15 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-warning"
                                                    >In progress</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>John</td>
                                            <td>53275533</td>
                                            <td>14 May 2017</td>
                                            <td>
                                                <label class="badge badge-info"
                                                    >Fixed</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Peter</td>
                                            <td>53275534</td>
                                            <td>16 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-success"
                                                    >Completed</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Dave</td>
                                            <td>53275535</td>
                                            <td>20 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-warning"
                                                    >In progress</label
                                                >
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- Table 2 -->
                    <div class="col-lg-6 grid-margin stretch-card">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title">Basic Table</h4>
                                <p class="card-description">
                                    Add class <code>.table</code>
                                </p>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Profile</th>
                                            <th>VatNo.</th>
                                            <th>Created</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Jacob</td>
                                            <td>53275531</td>
                                            <td>12 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-danger"
                                                    >Pending</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Messsy</td>
                                            <td>53275532</td>
                                            <td>15 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-warning"
                                                    >In progress</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>John</td>
                                            <td>53275533</td>
                                            <td>14 May 2017</td>
                                            <td>
                                                <label class="badge badge-info"
                                                    >Fixed</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Peter</td>
                                            <td>53275534</td>
                                            <td>16 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-success"
                                                    >Completed</label
                                                >
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Dave</td>
                                            <td>53275535</td>
                                            <td>20 May 2017</td>
                                            <td>
                                                <label
                                                    class="badge badge-warning"
                                                    >In progress</label
                                                >
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- table 3 -->
                    <div class="col-lg-12 grid-margin stretch-card">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title">Striped Table</h4>
                                <p class="card-description">
                                    Add class <code>.table-striped</code>
                                </p>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>First name</th>
                                            <th>Progress</th>
                                            <th>Amount</th>
                                            <th>Deadline</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="py-1">
                                                <img
                                                    src="@/assets/images/faces-clipart/pic-1.png"
                                                    alt="image"
                                                />
                                            </td>
                                            <td>Herman Beck</td>
                                            <td>
                                                <div class="progress">
                                                    <div
                                                        class="progress-bar bg-success"
                                                        role="progressbar"
                                                        style="width: 25%"
                                                        aria-valuenow="25"
                                                        aria-valuemin="0"
                                                        aria-valuemax="100"
                                                    ></div>
                                                </div>
                                            </td>
                                            <td>$ 77.99</td>
                                            <td>May 15, 2015</td>
                                        </tr>
                                        <tr>
                                            <td class="py-1">
                                                <img
                                                    src="@/assets/images/faces-clipart/pic-2.png"
                                                    alt="image"
                                                />
                                            </td>
                                            <td>Messsy Adam</td>
                                            <td>
                                                <div class="progress">
                                                    <div
                                                        class="progress-bar bg-danger"
                                                        role="progressbar"
                                                        style="width: 75%"
                                                        aria-valuenow="75"
                                                        aria-valuemin="0"
                                                        aria-valuemax="100"
                                                    ></div>
                                                </div>
                                            </td>
                                            <td>$245.30</td>
                                            <td>July 1, 2015</td>
                                        </tr>
                                        <tr>
                                            <td class="py-1">
                                                <img
                                                    src="@/assets/images/faces-clipart/pic-3.png"
                                                    alt="image"
                                                />
                                            </td>
                                            <td>John Richards</td>
                                            <td>
                                                <div class="progress">
                                                    <div
                                                        class="progress-bar bg-warning"
                                                        role="progressbar"
                                                        style="width: 90%"
                                                        aria-valuenow="90"
                                                        aria-valuemin="0"
                                                        aria-valuemax="100"
                                                    ></div>
                                                </div>
                                            </td>
                                            <td>$138.00</td>
                                            <td>Apr 12, 2015</td>
                                        </tr>
                                        <tr>
                                            <td class="py-1">
                                                <img
                                                    src="@/assets/images/faces-clipart/pic-4.png"
                                                    alt="image"
                                                />
                                            </td>
                                            <td>Peter Meggik</td>
                                            <td>
                                                <div class="progress">
                                                    <div
                                                        class="progress-bar bg-primary"
                                                        role="progressbar"
                                                        style="width: 50%"
                                                        aria-valuenow="50"
                                                        aria-valuemin="0"
                                                        aria-valuemax="100"
                                                    ></div>
                                                </div>
                                            </td>
                                            <td>$ 77.99</td>
                                            <td>May 15, 2015</td>
                                        </tr>
                                        <tr>
                                            <td class="py-1">
                                                <img
                                                    src="@/assets/images/faces-clipart/pic-1.png"
                                                    alt="image"
                                                />
                                            </td>
                                            <td>Edward</td>
                                            <td>
                                                <div class="progress">
                                                    <div
                                                        class="progress-bar bg-danger"
                                                        role="progressbar"
                                                        style="width: 35%"
                                                        aria-valuenow="35"
                                                        aria-valuemin="0"
                                                        aria-valuemax="100"
                                                    ></div>
                                                </div>
                                            </td>
                                            <td>$ 160.25</td>
                                            <td>May 03, 2015</td>
                                        </tr>
                                        <tr>
                                            <td class="py-1">
                                                <img
                                                    src="@/assets/images/faces-clipart/pic-2.png"
                                                    alt="image"
                                                />
                                            </td>
                                            <td>John Doe</td>
                                            <td>
                                                <div class="progress">
                                                    <div
                                                        class="progress-bar bg-info"
                                                        role="progressbar"
                                                        style="width: 65%"
                                                        aria-valuenow="65"
                                                        aria-valuemin="0"
                                                        aria-valuemax="100"
                                                    ></div>
                                                </div>
                                            </td>
                                            <td>$ 123.21</td>
                                            <td>April 05, 2015</td>
                                        </tr>
                                        <tr>
                                            <td class="py-1">
                                                <img
                                                    src="@/assets/images/faces-clipart/pic-3.png"
                                                    alt="image"
                                                />
                                            </td>
                                            <td>Henry Tom</td>
                                            <td>
                                                <div class="progress">
                                                    <div
                                                        class="progress-bar bg-warning"
                                                        role="progressbar"
                                                        style="width: 20%"
                                                        aria-valuenow="20"
                                                        aria-valuemin="0"
                                                        aria-valuemax="100"
                                                    ></div>
                                                </div>
                                            </td>
                                            <td>$ 150.00</td>
                                            <td>June 16, 2015</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- Fin Tableau -->
                </div>
    </AppLayout>
</template>
